# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling_using_class.rb'
require 'debug'

class TestReversi < Minitest::Test
  def test_score
    previous_frame = Frame.new([1,9])
    frame = Frame.new([1, 0])
    assert_equal frame.score, 1
    frame = Frame.new([3])
    assert_equal frame.score, 3
  end

  def test_spare
    frame = Frame.new([3,4])
    assert_equal false, frame.spare?
    frame = Frame.new([2,8])
    assert_equal true, frame.spare?
    frame = Frame.new([10])
    assert_equal false, frame.spare?
  end

  def test_strike
    frame = Frame.new([3,4])
    assert_equal false, frame.strike?
    frame = Frame.new([2,8])
    assert_equal false, frame.strike?
    frame = Frame.new([10])
    assert_equal true, frame.strike?
  end

  def test_spare_score_method
    previous_frame = Frame.new([1,9])
    frame = Frame.new([3,4],previous_frame)
    assert_equal frame.score_method, 10
  end

  def test_strike_score_method
    previous_frame = Frame.new([10])
    frame = Frame.new([3,4],previous_frame)
    assert_equal frame.score_method, 14
  end

  def test_frames
    all_pins = [1,2,3,4]
    assert_equal calculate_score(all_pins), 10
    all_pins = [1,2,3]
    assert_equal calculate_score(all_pins), 6
  end

  def test_calc_spare_score
    all_pins = [1,9,3,4]
    assert_equal calculate_score(all_pins), 20
    all_pins = [1,9,3]
    assert_equal calculate_score(all_pins), 16
  end

  def test_calc_strike_score
    all_pins = [1,9,3,4]
    assert_equal calculate_score(all_pins), 20
    all_pins = [1,9,3]
    assert_equal calculate_score(all_pins), 16
  end
end
