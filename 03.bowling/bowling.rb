#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10
BASIC_SIZE_1FRAME = 2

class Frame
  attr_accessor :points, :frame_num

  def initialize(previous_frame = nil, pre_previous_frame = nil)
    @points = []
    @previous_frame = previous_frame
    @pre_previous_frame = pre_previous_frame
    @frame_num = (previous_frame&.frame_num || 0) + 1
  end

  def score
    @points.sum + score_spare + score_strike
  end

  def spare?
    @points.size == BASIC_SIZE_1FRAME && @points.sum == MAX_PIN
  end

  def strike?
    @points.size < BASIC_SIZE_1FRAME && @points[0] == MAX_PIN
  end

  def max_throw_normal_frame?
    (@points.size >= BASIC_SIZE_1FRAME || strike?) && @frame_num < MAX_FRAME
  end

  private

  def score_spare
    if @previous_frame&.spare?
      @points[0]
    else
      0
    end
  end

  def score_strike
    if @previous_frame&.strike?
      sum = @points[0..1].sum
      sum += (@points[0] || 0) if @pre_previous_frame&.strike?
      sum
    else
      0
    end
  end
end

def calculate_score(all_pins)
  total_score = 0
  previous_frame = nil
  frame = Frame.new

  all_pins.each_with_index do |point, throw_num|
    frame.points << point
    final_frame = throw_num + 1 >= all_pins.size

    next unless frame.max_throw_normal_frame? || final_frame

    total_score += frame.score
    now_frame = frame
    frame = Frame.new(now_frame, previous_frame)
    previous_frame = now_frame
  end
  total_score
end

def convert_input_to_score(input)
  all_pins = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
  calculate_score(all_pins)
end

input = ARGV[0]
puts convert_input_to_score(input) unless input.nil?
