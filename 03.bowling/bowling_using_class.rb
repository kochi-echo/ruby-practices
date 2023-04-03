#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10

class Frame
  def initialize(points, previous_frame = nil, pre_previous_frame = nil)
    @points = points
    @previous_frame = previous_frame
    @pre_previous_frame = pre_previous_frame
  end

  def score
    pp score_strike_2past if score_strike_2past.nil?
    # debugger if score_strike_2past.nil?
    @points.sum + score_spare + score_strike_2past
  end

  def score_spare
    return 0 if @previous_frame.nil?
    if @previous_frame.spare?
      @points[0]
    else
      0
    end
  end

  def score_strike_2past
    return 0 if @previous_frame.nil?
    sum = score_strike(@previous_frame)
    if @pre_previous_frame.present? && @previous_frame.strike?
      sum = sum + score_strike(@pre_previous_frame)
    else
      sum
    end
  end

  def score_strike(frame)
    return 0 if frame.nil?
    if frame.strike?
      @points.sum
    else
      0
    end
  end

  def spare?
    @points.sum == 10 && @points.size == 2
  end

  def strike?
    @points[0] == 10
  end

end

class AllFrame


end


def separate_frame(pins)
  all_frame = []
  pins_1frame = []

  pins.each do |pin|
    pins_1frame << pin

    if pins_1frame[0] == 10 || pins_1frame.size == 2
      all_frame << pins_1frame
      pins_1frame = []
    end
  end

  all_frame << pins_1frame unless pins_1frame.empty?

  all_frame
end



def calculate_score(all_pins)
  score = 0
  previous_frame = nil
  pre_previous_frame = nil

  separate_frame(all_pins).each do |pins|
    frame = Frame.new(pins, previous_frame, pre_previous_frame)
    score += frame.score
    pre_previous_frame = previous_frame
    previous_frame = frame
  end

  score
end


# input = ARGV[0]

# unless input.nil?
#   input_array = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
#   puts calculate_score(input_array)
# end
