require 'test_helper'

class BlTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Bl.gem_version
  end

  def test_version_command
    out = capture_io { Bl::CLI.start %w(version) }.join('')
    assert(false == out.nil?, 'should not nil')
  end

  def test_config_command
    out = capture_io { Bl::CLI.start %w(config) }.join('')
    assert(false == out.nil?, 'should not nil')
  end
end
