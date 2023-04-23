#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10
BASIC_SIZE_1FRAME = 2
SPECIAL_SIZE_LAST_FRAME = 3

class Frame
  attr_accessor :points, :frame_num
  attr_reader :previous_frame

  def initialize(previous_frame: nil)
    @points = []
    @previous_frame = previous_frame
    @frame_num = (previous_frame&.frame_num || 0) + 1
  end

  def score
    @points.sum + score_spare + score_strike
  end

  def spare?
    @points.size >= BASIC_SIZE_1FRAME && @points[0..1].sum == MAX_PIN
  end

  def strike?
    @points[0] == MAX_PIN
  end

  def max_throw_1frame?
    if @frame_num < MAX_FRAME
      @points.size >= BASIC_SIZE_1FRAME || strike?
    else
      @points.size >= (strike? || spare? ? SPECIAL_SIZE_LAST_FRAME : BASIC_SIZE_1FRAME)
    end
  end

  private

  def score_spare
    @previous_frame&.spare? ? @points[0] : 0
  end

  def score_strike
    return 0 unless @previous_frame&.strike?

    two_frames_ago = @previous_frame.previous_frame
    sum = @points[0..1].sum
    sum += (@points[0] || 0) if two_frames_ago&.strike?
    sum
  end
end

def calculate_score(all_pins)
  total_score = 0
  frame = Frame.new

  all_pins.each_with_index do |point, throw_num|
    frame = Frame.new(previous_frame: frame) if frame&.max_throw_1frame? # 前フレームで最大まで投げた時に、新しいフレームを作成
    frame.points << point
    total_score += frame.score if frame&.max_throw_1frame? || (throw_num + 1 >= all_pins.size) # 現フレームで最大まで投げた or 最後の投球の時に現フレームの点数計算
  end
  total_score
end

def convert_input_to_score(input)
  all_pins = input.split(',').map { |pin| pin == 'X' ? 10 : pin.to_i }
  calculate_score(all_pins)
end

input = ARGV[0]
puts convert_input_to_score(input) unless input.nil?
