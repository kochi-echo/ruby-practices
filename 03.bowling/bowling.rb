#!/usr/bin/env ruby
# frozen_string_literal: true

class CalScore
  attr_writer :max_pin
  attr_reader :sum_score, :max_frame

  def initialize
    @score = 0 # 合計スコア
    @add_array = [] # ストライクやスペアで追加で可算する回数が要素として入る
    @pins_frame_array = [] # 1フレームで倒したピンの数が要素として入る(ストライク以外なら2要素)
    @max_frame = 10
    @sum_score = 0
    @frame_num = 0
  end

  def update_score(pin)
    @pins_frame_array.push(pin)
    update_frame
    add_score(pin)
    update_add_array

    @pins_frame_array = [] if @pins_frame_array.size > 1 || pin == @max_pin # 2回投げるかストライクを取ると1フレーム中の倒したピンはリセット

    # puts "#{@frame_num}回目: #{pin}倒して合計は#{@sum_score} （#{@add_array.size}個分追加で足された）" if @frame_num % 1 == 0
  end

  def update_frame
    if @pins_frame_array[0] == @max_pin && @frame_num < @max_frame # 前フレームがmax_frame以下の時にストライク判定
      @frame_num += 1 # ストライクの時は1フレーム追加
    elsif @frame_num < @max_frame
      @frame_num += 0.5 # ストライク以外の時は半フレーム追加
    end
  end

  def add_score(pin)
    @add_array.reject! { |elem| elem <= 0 }
    @sum_score += (@add_array.size + 1) * pin
    @add_array.map! { |elem| elem - 1 if elem.positive? }
  end

  def update_add_array
    if @pins_frame_array[0] == @max_pin && @frame_num < @max_frame # 現フレームがmax_frame以下の時にストライク判定
      @add_array.push(2) # 2回分点数追加
    elsif @pins_frame_array.sum == @max_pin && @frame_num < @max_frame # 現フレームがmax_frame以下の時にスペア判定
      @add_array.push(1) # 1回分点数追加
    end
  end
end

full_pin = 10

input = ARGV[0]
input_array = input.gsub('X', full_pin.to_s).split(',').map(&:to_i) # X->10に置換

score_data = CalScore.new
score_data.max_pin = full_pin

input_array.each do |pin|
  score_data.update_score(pin)
end

puts score_data.sum_score
