require 'test_helper'

class Paperclip::OssTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Paperclip::Oss::VERSION
  end

  def test_that_it_has_exceptions_module_and_exception_classes
    refute_nil ::Paperclip::Oss::Exceptions
    refute_nil ::Paperclip::Oss::Exceptions::Error
    refute_nil ::Paperclip::Oss::Exceptions::UploadFailed
    refute_nil ::Paperclip::Oss::Exceptions::OptionsError
  end

  # TODO: add more tests
end
