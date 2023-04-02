#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_PIN = 10
MAX_FRAME = 10

def calculate_score(input_array)
  score = 0 # 合計スコア
  frame = 0 # フレーム数
  add_extra_array = [] # ストライクやスペアで追加で可算する回数（カウント）が要素として入る
  pins_1frame_array = [] # 1フレームで倒したピンの数が要素として入る(ストライク以外なら2要素)

  input_array.each do |pin|
    pins_1frame_array.push(pin)
    score += (add_extra_array.size + 1) * pin # 現在の点数とカウントにより追加が必要な点数を加算
    add_extra_array.map! { |elem| elem - 1 if elem.positive? } # 点数を追加するカウントを減らす
    add_extra_array.reject! { |elem| elem <= 0 } # カウント0の要素を削除

    if pins_1frame_array[0] == MAX_PIN
      frame += 1 if frame < MAX_FRAME
      add_extra_array.push(2) if frame < MAX_FRAME # 2回分点数追加
    elsif pins_1frame_array.sum == MAX_PIN
      frame += 0.5 if frame < MAX_FRAME
      add_extra_array.push(1) if frame < MAX_FRAME # 1回分点数追加
    else
      frame += 0.5 if frame < MAX_FRAME
    end

    pins_1frame_array = [] if pins_1frame_array.size > 1 || pins_1frame_array[0] == MAX_PIN # 2回投げるかストライクを取ると1フレーム中の倒したピンはリセット
  end

  score
end

input = ARGV[0]

unless input.nil?
  input_array = input.gsub('X', MAX_PIN.to_s).split(',').map(&:to_i) # X->10に置換
  puts calculate_score(input_array)
end
