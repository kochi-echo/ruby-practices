#!/usr/bin/env ruby


=begin
# 要件

## ルール
- 1ゲーム=10フレーム。
- 1フレーム=2投。（例外あり）
- ピンの数は10本。
- 1投目で10本倒したらストライク。
- ストライクの場合は2投目は表記しない。
- 1投目で全て倒せなかった時、2投目で全て倒したらスペア。
- スペアのフレームの得点は次の1投の点を加算する。
- ストライクのフレームの得点は次の2投の点を加算する。
- 10フレーム目は1投目がストライクもしくは2投目がスペアだった場合、3投目が投げられる。
- ありえない投球数やありえない数字・記号がこない前提。

## 提出にあたって
- rubocop-fjordパスしているか？
- 組み込み・標準添付ライブラリの単語を使っているか？
- クラスは名詞、メソッドは動詞か？
- 頻出名詞をクラスに抜き出す
- ハッシュテーブルによる分岐数削減
- 引数のないメソッドは可読性のためインスタンス変数っぽく名詞の名前をつける
- 1メソッドは五行以内に収めるべし

# 方針
- 小さく作る
    - 入力は'X,4,4', '4,6,4', '4,3,4'
    - まずはeachを使わず、未来も見通せることとする -> if文だけで書けるが、'X,X,4,4'に対応できなかった
- 基本構成
    - 基本は倒したピンの可算
    - strike、spareになるごとにメソッドを呼び出す ->いらなかった
    - strike時: strike後2回分倒したピンを可算する
        - strikeをしたらcount=2を生成
        - 次の周でcount>0だったら現在の倒したピンを可算し、countを1減らす
        課題：どうやってストライクが発生するたびに新たなcountを生成し、ループを超えて生き残らせるか？
        ->sum_count.push!(2)をして、sum_count.sizeかけるピン数追加で可算していけば良い
    - spare時: sum_count.push!(1)をして、sum_count.sizeかけるピン数追加で可算していけば良い
=end

require 'debug'



input_data = [
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X',
'0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8',
'X,X,X,X,X,X,X,X,X,X,X,X'
]

input = input_data[4]

puts input

full_pin = 10
score = 0
sum_count = []
previous_pin = 0
throw_count = []
frame = 0
max_frame = 10

input_array = input.gsub('X', full_pin.to_s).split(',').map{ |elem| elem.to_i }

input_array.each_with_index{ |pin, index|

        throw_count.push(pin)
        if (throw_count[0] == full_pin && frame < max_frame)
            frame += 1
        elsif frame < max_frame
            frame += 0.5
        end

        sum_count.reject!{|elem| elem <= 0}
        score += (sum_count.size + 1) * pin
        sum_count.map!{|elem| elem - 1 if elem > 0}

        if (throw_count[0] == full_pin && frame < max_frame)
            sum_count.push(2)

        elsif (throw_count.sum == full_pin && frame < max_frame)
            sum_count.push(1)
        end

        throw_count = [] if (throw_count.size > 1 || pin == full_pin)

        # puts "#{times}回目: #{pin}倒して合計は#{score} （#{sum_count.size}個分追加で足された）" if times%1 == 0
        # p sum_count
}

puts score
    


