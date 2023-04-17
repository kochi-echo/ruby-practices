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

  def spare?
    @points.size == BASIC_SIZE_1FRAME && @points.sum == MAX_PIN
  end

  def strike?
    @points.size < BASIC_SIZE_1FRAME && @points[0] == MAX_PIN
  end

  def throw_max_each_frame?
    @points.size >= BASIC_SIZE_1FRAME || strike?
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
      sum += @points[0] if @pre_previous_frame&.strike?
      sum
    else
      0
    end
  end
end

def calculate_score(all_pins)
  previous_frame = nil
  pre_previous_frame = nil
  frame_count = 1
  pairs = []
  total_score = 0

  all_pins.each_with_index do |pin, throw_num|
    pairs << pin
    frame = Frame.new(pairs, previous_frame, pre_previous_frame)
    necessary_reset_pairs = frame.throw_max_each_frame? && frame_count < MAX_FRAME

    next unless throw_num + 1 >= all_pins.size || necessary_reset_pairs

    total_score += frame.score
    pairs = []
    frame_count += 1
    pre_previous_frame = previous_frame
    previous_frame = frame
  end
  total_score
end

def generate_score(input)
  all_pins = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
  calculate_score(all_pins)
end

input = ARGV[0]
puts generate_score(input) unless input.nil?
