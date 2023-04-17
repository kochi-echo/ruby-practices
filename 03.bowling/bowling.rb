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

def now_1st_throw?(pairs_all_frames, pairs_previous_frame)
  pairs_all_frames.empty? || pairs_previous_frame.size >= BASIC_SIZE_1FRAME || (pairs_previous_frame[0] || 0) >= MAX_PIN
end

def separate_frame(all_pins)
  all_pins.each_with_object([]) do |pin, pairs_all_frames|
    pairs_previous_frame = pairs_all_frames.last || []
    if now_1st_throw?(pairs_all_frames, pairs_previous_frame) && pairs_all_frames.size < MAX_FRAME
      pairs_all_frames << [pin] # 新しいフレームの生成
    else
      pairs_previous_frame << pin # 既存のフレームに追加
    end
  end
end

def calculate_score(all_pins)
  previous_frame = nil
  pre_previous_frame = nil

  separate_frame(all_pins).sum do |pins|
    frame = Frame.new(pins, previous_frame, pre_previous_frame)
    pre_previous_frame = previous_frame
    previous_frame = frame
    frame.score
  end
end

def generate_score(input)
  all_pins = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
  calculate_score(all_pins)
end

input = ARGV[0]
puts generate_score(input) unless input.nil?
