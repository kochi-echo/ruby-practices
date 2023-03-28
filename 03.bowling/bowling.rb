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
  - まずはeachを使わず、未来も見通せることとする

- 10回ループ
- 以下のクラスをメソッドを置く
  - ストライク時の処理
  - スペア時の処理
  - 普通の時の処理

=end

require 'debug'



def calc_score(pin, sum_score, sum_count)
    if sum_count > 0
        sum_score += pin * 2
        sum_count -= 1
    else
        sum_score += pin
    end
    {count: sum_count, score: sum_score}
end

input_data = [
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X',
'0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0',
'6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8',
'X,X,X,X,X,X,X,X,X,X,X,X'
]

input = input_data[2]
puts input

full_pin = 10
score = 0
sum_count = 0
previous_pin = 0
throw_count = []
times = 0
max_frame = 10

input_array = input.gsub('X', full_pin.to_s).split(',').map{ |elem| elem.to_i }

input_array.each_with_index{ |pin, index|
    # if pin == full_pin
        # debuggerß
    # end
    throw_count.push(pin)

    if (throw_count[0] == full_pin && times < max_frame)
        times += 1
    elsif times < 10
        times += 0.5
    end
    
    if (throw_count[0] == full_pin && times < max_frame)
        score = calc_score(pin, score, sum_count)[:score]
        sum_count += 2

    elsif (throw_count.sum == full_pin && times < max_frame)
        score = calc_score(pin, score, sum_count)[:score]
        sum_count = 1  

    else
        result = calc_score(pin, score, sum_count)
        score = result[:score]
        sum_count = result[:count]
    end
    throw_count = [] if (throw_count.size > 1 || pin == 10)
    puts "#{times}回目: #{pin}倒して合計#{score} 次の#{sum_count}分足される" if times%1 == 0
}

puts score
    


