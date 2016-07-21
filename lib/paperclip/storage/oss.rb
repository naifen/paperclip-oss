module Paperclip
  module Storage
    module Oss
      def self.extended base
        begin
          require 'aliyun/oss'
        rescue LoadError => e
          e.message << " (You may need to install the aliyun gem)"
          raise e
        end unless defined?(::Aliyun::OSS)

        base.instance_eval do
          unless @options[:oss]
            raise Paperclip::Oss::Exceptions::OptionsError, '(You should set OSS options)'
          end

          @bucket = @options[:oss][:bucket]
          @access_key_id = @options[:oss][:access_key_id]
          @access_key_secret = @options[:oss][:access_key_secret]
          @endpoint = @options[:oss][:endpoint]

          @oss = Aliyun::OSS::Client.new(
            endpoint: @endpoint,
            access_key_id: @access_key_id,
            access_key_secret: @access_key_secret)

          @options[:path] = @options[:path].gsub(/:url/, @options[:url])
          @options[:url] = ':oss_public_url'

          Paperclip.interpolates(:oss_public_url) do |attachment, style|
            # see doc https://github.com/thoughtbot/paperclip/wiki/Interpolations
            attachment.public_url(style)
          end unless Paperclip::Interpolations.respond_to? :oss_public_url
        end
      end

      def exists?(style = default_style)
        begin
          result = @oss.get_bucket(@bucket).object_exists?(path(style))
        rescue => err
          log("OSS<ERROR>: #{err}")
        end

        result
      end

      def flush_writes
        for style, file in @queued_for_write do
          log("saving #{path(style)}")
          retried = false
          begin
            upload(file, path(style))
          ensure
            file.rewind
          end
        end
        after_flush_writes # allows attachment to clean up temp files
        @queued_for_write = {}
      end

       def flush_deletes
        for path in @queued_for_delete do
          delete(path)
        end
        @queued_for_delete = []
      end

      def public_url(style = default_style)
        bucket_url = @endpoint.dup
        bucket_url.insert(7, @bucket + ".") unless @endpoint.start_with?("https")
        url = "#{bucket_url}/#{path(style)}"
      end

      private

      def upload(file, path)
        begin
          @oss.get_bucket(@bucket).put_object(path, file: File.new(file.path,"rb"))
        rescue => err
          log("OSS<ERROR>: #{err}")
          raise Paperclip::Oss::Exceptions::UploadFailed
        end
      end

      def delete(path)
        begin
          @oss.get_bucket(@bucket).delete_object(path)
        rescue => err
          log("OSS<ERROR>: #{err}")
        end
      end
    end
  end
end
