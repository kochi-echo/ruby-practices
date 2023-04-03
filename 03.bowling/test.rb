# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling'

INPUT_SAMPLE_DATA = [
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X',
  '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0',
  '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8',
  'X,X,X,X,X,X,X,X,X,X,X,X'
]

OUTPUT_SAMPLE_DATA = [139, 164, 107, 134, 144, 300]

class TestReversi < Minitest::Test
  def test_score_equal
    (0..(INPUT_SAMPLE_DATA.size - 1)).each do |index|
      input_array = INPUT_SAMPLE_DATA[index].gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
      assert_equal calculate_score(input_array), OUTPUT_SAMPLE_DATA[index]
    end
  end
end
