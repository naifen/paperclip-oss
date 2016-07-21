# paperclip-oss

A [Paperclip](https://github.com/thoughtbot/paperclip) plugin enables upload to Aliyun OSS.

Dependency [aliyun-sdk](https://github.com/aliyun/aliyun-oss-ruby-sdk).

This gem is different from [paperclip-storage-aliyun](https://github.com/Martin91/paperclip-storage-aliyun) which does NOT depend on aliyun-sdk. Pick your own flavor.

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'paperclip'
gem 'paperclip-oss'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-oss

## Usage

* create `config/initializers/paperclip.rb` or your program initializer. code configation as follow:

```
Paperclip::Attachment.default_options[:storage] = :oss
Paperclip::Attachment.default_options[:oss] = {
  endpoint: 'http://oss-us-west-1.aliyuncs.com', # change this to ur data center endpoint
  access_key_id: ENV['OSS_ACCESS_KEY_ID'],
  access_key_secret: ENV['OSS_ACCESS_KEY_SECRET'],
  bucket: ENV['OSS_BUCKET'],
}
```

* add paperclip config in your model:

```
class User < ActiveRecord::Base

    has_attached_file :avatar,
        styles: { medium: "300x300>", thumb: "100x100>" },
        default_url: "/images/:style/missing.png",
        path: 'path/to/ur/files/:class/:attachment/:id_partition/:style/:filename'

    # validates :avatar, :attachment_presence => true
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
```
## TODO
Add more tests.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paperclip-oss. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

