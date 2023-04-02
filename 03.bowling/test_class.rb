# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling_using_class.rb'
require 'debug'

class TestReversi < Minitest::Test
  def test_score_method
    previous_frame = Frame.new([1,9])
    frame = Frame.new([1, 0])
    assert_equal frame.score_method, 1
    frame = Frame.new([3])
    assert_equal frame.score_method, 3
  end

  def test_spare_score_method
    previous_frame = Frame.new([1,9])
    frame = Frame.new([3,4],previous_frame)
    assert_equal frame.score_method, 10
  end

  def test_strike_score_method
    previous_frame = Frame.new([10])
    frame = Frame.new([3,4],previous_frame)
    # debugger
    assert_equal frame.score_method, 14
  end

  def test_frames
    all_pins = [1,2,3,4]
    assert_equal calculate_score(all_pins), 10
    all_pins = [1,2,3]
    assert_equal calculate_score(all_pins), 6
  end

  def test_spare_score
    all_pins = [1,9,3,4]
    assert_equal calculate_score(all_pins), 20
    all_pins = [1,9,3]
    assert_equal calculate_score(all_pins), 16
  end

  def test_strike_score
    all_pins = [1,9,3,4]
    assert_equal calculate_score(all_pins), 20
    all_pins = [1,9,3]
    assert_equal calculate_score(all_pins), 16
  end
end
