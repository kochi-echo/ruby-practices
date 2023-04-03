# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling_using_class.rb'
require 'debug'

class TestBowling < Minitest::Test
  def test_score
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

  def test_score_spare
    previous_frame = Frame.new([1,9])
    frame = Frame.new([3,4],previous_frame)
    assert_equal 3, frame.score_spare
  end

  def test_score_strike
    previous_frame = Frame.new([10])
    frame = Frame.new([3,4],previous_frame)
    assert_equal 7, frame.score_strike_2past
  end

  def test_calc_normal_score
    all_pins = [1,2,3,4]
    assert_equal 10, calculate_score(all_pins)
    all_pins = [1,2,3]
    assert_equal 6, calculate_score(all_pins)
  end

  def test_calc_spare_score
    all_pins = [1,9,3,4]
    assert_equal 20, calculate_score(all_pins)
    all_pins = [1,9,3]
    assert_equal 16, calculate_score(all_pins)
  end

  def test_calc_strike_score
    all_pins = [10,3,4]
    assert_equal 24, calculate_score(all_pins)
    all_pins = [10,3]
    assert_equal 16, calculate_score(all_pins)
    all_pins = [10,2,3,10,2,3]
    assert_equal 40, calculate_score(all_pins)
    all_pins = [10,10,10,2,3]
    assert_equal 35 + 20 + 15 + 5, calculate_score(all_pins)
    all_pins = [10,10,10,2]
    assert_equal 32 + 20 + 12 + 2, calculate_score(all_pins)
  end

  def test_separate_frame
    all_pins = [1,2,3,4]
    assert_equal [[1,2],[3,4]], separate_frame(all_pins)
    all_pins = [1,2,3]
    assert_equal [[1,2],[3]], separate_frame(all_pins)
  end
end
