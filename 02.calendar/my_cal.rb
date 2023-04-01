#!/usr/bin/env ruby

require 'date'
require 'optparse'

NORMAL_COLOR = '38;5;208' # オレンジ
INVERT_COLOR = '7' # 白
DAYOFWEEK_JP_ARRAY = %w[日 月 火 水 木 金 土]
MONTH_MIN = 1
MONTH_MAX = 12
YEAR_MIN = 1970
YEAR_MAX = 2100
WIDTH_1DAY = 2
WIDTH_CALENDER = 20

def color_text(text, color) # 文字の色の変更
  "\033[" + color + "m#{text}\033[0m"
end

def color_days(date) # 日にの調整をして、日にちの文字列を出力する
  day = date.day.to_s.rjust(WIDTH_1DAY)
  if date == Date.today # 今日の日付は色を反転する
    color_text(day, INVERT_COLOR)
  else
    color_text(day, NORMAL_COLOR)
  end
end

def print_month_year(year, month, length, color) # 月と年を表示
  year_month_str = "#{month}月 #{year}年".center(length) + "\n"
  text_center = year_month_str.center(length)
  text_center.gsub!(/\d+/) { |str| text_color(str, color) } # 数字だけ色変更
  print text_center
end

def date_adjust(date, normal, invert) # 日にの調整をして、日にちの文字列を出力する
  day = if date.day < 10 # 日にちが一桁だと他の数字と位置がズレるので修正
          " #{date.day}"
        else
          date.day
        end
  if date == Date.today # 今日の日付は色を反転する
    text_color(day, invert)
  else
    text_color(day, normal)
  end
end

def days_alignment(first, last, normal, invert) # 初日から最終日までを算出し、日にちの配列を出力する
  days_array_origin = (first..last).to_a
  days_alignment_array = days_array_origin.map do |date|
    date_adjust(date, normal, invert)
  end
  days_array = (['  '] * first.cwday) + days_alignment_array # 初日の曜日を合わせる
end

def calc_month_days(year, month, normal, invert) # 1ヶ月の日にちを算出し、一週間ごとに区切って出力
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  week_enum = days_alignment(first_date, last_date, normal, invert).each_slice(7)
end

def print_month(year, month) # 1ヶ月のカレンダーを表示
  normal_color = '38;5;208' # オレンジ
  invert_color = '7' # 白
  dayofweek_jp_array = %w[日 月 火 水 木 金 土]

  length_dayofweek = length_2byte(dayofweek_jp_array.join(' ')) # 月の表示を真ん中に持ってくるために列の数を計算
  print_month_year(year, month, length_dayofweek, normal_color)
  print(dayofweek_jp_array.join(' ') + "\n")

  week_enum = calc_month_days(year, month, normal_color, invert_color)
  (1..week_enum.size).each { print week_enum.next.join(' ') + "\n" }
end

def check_month(month) # 月オプションの例外処理
  if month.nil? # 未入力時の対応
    month = Date.today.month
    text = nil
  elsif month.to_i < 1 || month.to_i > 12 # 規定外の入力時の対応
    text = "calendar: #{month.to_i} is neither a month number (1..12) nor a name "
  end
  [month.to_i, text]
end

def check_year(year, text) # 年オプションの例外処理
  if year.nil? # 未入力時の対応
    year = Date.today.year
  elsif year.to_i < 1 || year.to_i > 9999 # 規定外の入力時の対応
    text = "calendar: year `#{year.to_i}' not in range 1..9999"
  end
  [year.to_i, text]
end

# main
option = ARGV.getopts('m:', 'y:')
result_month, errot_text = check_month(option['m']) #-m 月オプションの入力と例外処理
result_year, error_text = check_year(option['y'], errot_text) # 年オプションの入力と例外処理

if error_text.nil?
  print_month(result_year, result_month)
else
  puts result_year
end
