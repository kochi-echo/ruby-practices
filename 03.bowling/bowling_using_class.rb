#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10

class Frame
  attr_reader :points
  def initialize(points, previous_frame = nil)
    @points = points
    @previous_frame = previous_frame
  end

  def score_method()
    @points.sum + score_spare + score_strike
  end

  def score_spare
    return 0 if @previous_frame.nil? || @previous_frame.points.size == 1
    if @previous_frame.points.sum == 10
      @points[0]
    else
      0
    end
  end

  def score_strike
    return 0 if @previous_frame.nil?
    if @previous_frame.points[0] == 10
      @points.sum
    else
      0
    end
  end

end

def calculate_score(pins)
  score = 0
  previous_frame = nil
  pins.each_slice(2) do |pins|
    frame = Frame.new(pins, previous_frame)
    score += frame.score_method
    previous_frame = frame
  end
  score
end

# def calculate_score(input_array)
#   input_array.each do ||
#     frame = Frame.new([1, 0])
#     score += frame.score_method
#   end

#   score
# end

# input = ARGV[0]

# unless input.nil?
#   input_array = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
#   puts calculate_score(input_array)
# end
