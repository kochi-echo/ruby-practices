#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10
BASIC_SIZE_1FRAME = 2

class Frame
  def initialize(points, previous_frame = nil, pre_previous_frame = nil)
    @points = points
    @previous_frame = previous_frame
    @pre_previous_frame = pre_previous_frame
  end

  def score
    @points.sum + score_spare + score_strike
  end

  def score_spare
    if !@previous_frame.nil? && @previous_frame.spare?
      @points[0]
    else
      0
    end
  end

  def score_strike
    if !@previous_frame.nil? && @previous_frame.strike?
      sum = @points[0]
      sum += @points[1] if @points.size >= BASIC_SIZE_1FRAME
      sum += @points[0] if !@pre_previous_frame.nil? && @pre_previous_frame.strike?
      sum
    else
      0
    end
  end

  def spare?
    @points.size == BASIC_SIZE_1FRAME && @points.sum == MAX_PIN
  end

  def strike?
    @points.size == BASIC_SIZE_1FRAME - 1 && @points[0] == MAX_PIN
  end
end

def pin_data2int(input)
  input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
end

def separate_frame(pins)
  all_frame = []
  pins_1frame = []

  pins.each do |pin|
    pins_1frame << pin
    maxsize_1frame = all_frame.size >= MAX_FRAME - 1 ? 3 : 2

    if (pins_1frame[0] == 10 && all_frame.size < MAX_FRAME - 1) || pins_1frame.size == maxsize_1frame
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

input = ARGV[0]

unless input.nil?
  input_array = pin_data2int(input)
  puts calculate_score(input_array)
end
