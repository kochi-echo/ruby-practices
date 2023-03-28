#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0]

full_pin = 10
score = 0 # 合計スコア
add_array = [] # ストライクやスペアで追加で可算する回数が要素として入る
pins_frame_array = [] # 1フレームで倒したピンの数が要素として入る(ストライク以外なら2要素)
frame = 0 # フレーム数
max_frame = 10

input_array = input.gsub('X', full_pin.to_s).split(',').map(&:to_i) # X->10に置換

input_array.each do |pin|
	pins_frame_array.push(pin)
	if pins_frame_array[0] == full_pin && frame < max_frame # 前フレームがmax_frame以下の時にストライク
		frame += 1 # ストライクの時は1フレーム追加
	elsif frame < max_frame
		frame += 0.5 # ストライク以外の時は半フレーム追加
	end

	add_array.reject!{|elem| elem <= 0}
	score += (add_array.size + 1) * pin
	add_array.map!{|elem| elem - 1 if elem > 0}

	if pins_frame_array[0] == full_pin && frame < max_frame # 現フレームがmax_frame以下の時にストライク
		add_array.push(2) # 2回分点数追加
	elsif pins_frame_array.sum == full_pin && frame < max_frame # 現フレームがmax_frame以下の時にスペア
		add_array.push(1) # 1回分点数追加
	end

	pins_frame_array = [] if pins_frame_array.size > 1 || pin == full_pin # 2回投げるかストライクを取ると1フレーム中の倒したピンはリセット

	# puts "#{frame}回目: #{pin}倒して合計は#{score} （#{add_array.size}個分追加で足された）" if frame%1 == 0
end

puts score
    


