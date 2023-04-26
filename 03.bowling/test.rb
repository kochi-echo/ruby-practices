#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling'

class TestFrameMethod < Minitest::Test
  def test_score
    frame = Frame.new
    frame.points = [1, 0]
    assert_equal 1, frame.score
    frame = Frame.new
    frame.points = [3]
    assert_equal 3, frame.score
  end

  def test_spare
    frame = Frame.new
    frame.points = [3, 4]
    refute frame.spare?
    frame = Frame.new
    frame.points = [2, 8]
    assert frame.spare?
    frame = Frame.new
    frame.points = [10]
    refute frame.spare?
    frame = Frame.new
    frame.points = [0, 10]
    assert frame.spare?
  end

  def test_strike
    frame = Frame.new
    frame.points = [3, 4]
    refute frame.strike?
    frame = Frame.new
    frame.points = [2, 8]
    refute frame.strike?
    frame = Frame.new
    frame.points = [10]
    assert frame.strike?
  end

  def test_max_throw_1frame
    frame = Frame.new
    frame.points = [3]
    refute frame.max_throw_1frame?
    frame = Frame.new
    frame.points = [2, 8]
    assert frame.max_throw_1frame?
    frame = Frame.new
    frame.points = [10]
    assert frame.max_throw_1frame?

    frame.points = [3]
    frame.frame_num = 10
    refute frame.max_throw_1frame?
    frame = Frame.new
    frame.points = [2, 8]
    frame.frame_num = 10
    refute frame.max_throw_1frame?
    frame = Frame.new
    frame.points = [10]
    frame.frame_num = 10
    refute frame.max_throw_1frame?
  end
end

class TestSmallScoreCalculation < Minitest::Test
  def test_calc_normal_score
    all_pins = [1, 2, 3, 4]
    assert_equal 10, calculate_score(all_pins)
  end

  def test_calc_spare_score
    all_pins = [1, 9, 3, 4]
    assert_equal 20, calculate_score(all_pins)
    all_pins = [0, 10, 1, 2]
    assert_equal 14, calculate_score(all_pins)
  end

  def test_calc_strike_score
    all_pins = [10, 3, 4]
    assert_equal 24, calculate_score(all_pins)
    all_pins = [10, 2, 3, 10, 2, 3]
    assert_equal 40, calculate_score(all_pins)
    all_pins = [10, 10, 10, 2, 3]
    assert_equal 35 + 20 + 12 + 5, calculate_score(all_pins)
  end
end

class TestGenerationScore < Minitest::Test
  def test_strike_and_spare
    assert_equal [6, 3, 9, 0, 0, 3, 8, 2].sum, convert_input_to_score('6,3,9,0,0,3,8,2')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10]].flatten.sum + 7 + 10, convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0]].flatten.sum + 7 + 10 + 10 + 8,
                 convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0')
    assert_equal [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0], [10]].flatten.sum + 7 + 10 + 10 + 8,
                 convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X')
    assert_equal 139, convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
  end

  def test_last_frame_3throw
    assert_equal 164, convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
  end

  def test_3strike
    assert_equal [0, 10, 1, 5, 0, 0, 0, 0].sum + 1, convert_input_to_score('0,10,1,5,0,0,0,0')
    assert_equal [0, 10, 1, 5, 0, 0, 0, 0, 10, 10, 10, 5, 1].sum + 1 + [10, 10].sum + [10, 5].sum + [5, 1].sum,
                 convert_input_to_score('0,10,1,5,0,0,0,0,X,X,X,5,1')
    assert_equal 107, convert_input_to_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
  end

  def test_other_scores
    assert_equal 134, convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 144, convert_input_to_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 300, convert_input_to_score('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
