require 'minitest/autorun'

class SanityCheck < Minitest::Test
  def test_math_works
    assert_equal 2 + 2, 4
  end
end
