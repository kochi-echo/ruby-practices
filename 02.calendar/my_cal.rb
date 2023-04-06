#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

NORMAL_COLOR = '38;5;208' # オレンジ
INVERT_COLOR = '7' # 白
DAY_OF_WEEKS = %w[日 月 火 水 木 金 土].freeze
MONTH_MIN = 1
MONTH_MAX = 12
YEAR_MIN = 1970
YEAR_MAX = 2100
WIDTH_1DAY = 2
WIDTH_CALENDER = 20

def color_text(text, color)
  "\e[#{color}m#{text}\033[0m"
end

def color_days(date)
  day = date.day.to_s.rjust(WIDTH_1DAY)
  if date == Date.today # 今日の日付は色を反転する
    color_text(day, INVERT_COLOR)
  else
    color_text(day, NORMAL_COLOR)
  end
end

def align_days(first, last)
  dates = (first..last).to_a
  days_colored = dates.map do |date|
    color_days(date)
  end
  ([' ' * WIDTH_1DAY] * first.wday) + days_colored # 初日の曜日を合わせる
end

def convert_year_month2text(year, month)
  year_month_text = "#{"#{month}月 #{year}年".center(WIDTH_CALENDER)}\n"
  year_month_text.gsub!(/\d+/) { |str| color_text(str, NORMAL_COLOR) } # 数字だけ色変更
end

def days2weeks(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  align_days(first_date, last_date).each_slice(7)
end

def print_calender(year, month)
  print convert_year_month2text(year, month)
  print("#{DAY_OF_WEEKS.join(' ')}\n")
  weeks = days2weeks(year, month)
  (1..weeks.size).each { print "#{weeks.next.join(' ')}\n" }
end

def year_in_range?(year)
  if (YEAR_MIN..YEAR_MAX).cover?(year)
    true
  else
    puts "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。"
    false
  end
end

def month_in_range?(month)
  if (MONTH_MIN..MONTH_MAX).cover?(month)
    true
  else
    puts "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}の範囲外です。"
    false
  end
end

def convert_input2month_year(option_y_m)
  option_y = option_y_m['y']
  option_m = option_y_m['m']
  year = option_y.nil? ? Date.today.year : option_y.to_i
  month = option_m.nil? ? Date.today.month : option_m.to_i
  [year, month]
end

def validation_year_month_in_range?(year, month)
  result_year_in_range = year_in_range?(year)
  result_month_in_range = month_in_range?(month)
  result_year_in_range && result_month_in_range
end

option_y_m = ARGV.getopts('y:', 'm:')
year, month = convert_input2month_year(option_y_m)
print_calender(year, month) if validation_year_month_in_range?(year, month)
