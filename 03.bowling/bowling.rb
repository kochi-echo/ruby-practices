#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10

score = 0 # 合計スコア
frame = 0 # フレーム数
add_array = [] # ストライクやスペアで追加で可算する回数が要素として入る
pins_frame_array = [] # 1フレームで倒したピンの数が要素として入る(ストライク以外なら2要素)

input = ARGV[0]
input_array = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換

input_array.each do |pin|
  pins_frame_array.push(pin)
  score += (add_array.size + 1) * pin
  add_array.map! { |elem| elem - 1 if elem.positive? }
  add_array.reject! { |elem| elem <= 0 }

  if pins_frame_array[0] == MAX_PIN
    frame += 1
    add_array.push(2) if frame < MAX_FRAME # 2回分点数追加
  elsif pins_frame_array.sum == MAX_PIN
    frame += 0.5
    add_array.push(1) if frame < MAX_FRAME # 1回分点数追加
  else
    frame += 0.5
  end

  pins_frame_array = [] if pins_frame_array.size > 1 || pin == MAX_PIN # 2回投げるかストライクを取ると1フレーム中の倒したピンはリセット
end

puts score
