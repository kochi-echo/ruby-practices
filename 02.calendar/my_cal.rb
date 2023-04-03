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

def align_days(first, last) # 初日から最終日までを算出し、日にちの配列を出力する
  dates_array = (first..last).to_a
  days_colored = dates_array.map do |date|
    color_days(date)
  end
  ([' ' * WIDTH_1DAY] * first.wday) + days_colored # 初日の曜日を合わせる
end

def print_month_year(year, month) # 月と年を表示
  year_month_str = "#{month}月 #{year}年".center(WIDTH_CALENDER) + "\n"
  year_month_str.gsub!(/\d+/) { |str| color_text(str, NORMAL_COLOR) } # 数字だけ色変更
  print year_month_str
end

def print_days(year, month) # 1ヶ月の日にちを算出し、一週間ごとに区切って表示
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  week_enum = align_days(first_date, last_date).each_slice(7)
  (1..week_enum.size).each { print week_enum.next.join(' ') + "\n" }
end

def print_calender(year, month) # 1ヶ月のカレンダーを表示
  print_month_year(year, month)
  print(DAYOFWEEK_JP_ARRAY.join(' ') + "\n")
  print_days(year, month)
end

def year_in_range?(year)
  return true if year >= YEAR_MIN && year <= YEAR_MAX
  puts "#{year}年は#{YEAR_MIN}〜#{YEAR_MAX}の範囲外です。"
  false
end

def month_in_range?(month)
  return true if month >= MONTH_MIN && month <= MONTH_MAX
  puts "#{month}月は#{MONTH_MIN}〜#{MONTH_MAX}の範囲外です。"
  false
end

# main
option_y_m = ARGV.getopts('y:', 'm:')

y = option_y_m['y']
m = option_y_m['m']
year = y.nil? ? Date.today.year : y.to_i
month = m.nil? ? Date.today.month : m.to_i

bool_year_range = year_in_range?(year)
bool_month_range = month_in_range?(month)
print_calender(year, month) if bool_year_range && bool_month_range
