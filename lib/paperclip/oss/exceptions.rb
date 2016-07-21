module Paperclip
  module Oss
    module Exceptions
      class Error < StandardError; end
      class UploadFailed < Error; end
      class OptionsError < Error; end
    end
  end
end
