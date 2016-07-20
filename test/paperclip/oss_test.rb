require 'test_helper'

class Paperclip::OssTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Paperclip::Oss::VERSION
  end

  def test_it_does_something_useful
    assert_equal ::Paperclip::Oss.foo, 'bar'
  end
end
