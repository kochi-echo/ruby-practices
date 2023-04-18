#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

NORMAL_COLOR = '38;5;208' # オレンジ
INVERT_COLOR = '7' # 白
YEAR_MIN = 1970
YEAR_MAX = 2100
MONTH_MIN = 1
MONTH_MAX = 12
WIDTH_1DAY = 2
WIDTH_CALENDER = 20

def color_text(text, color)
  "\e[#{color}m#{text}\033[0m"
end

def color_days(date, today)
  day = date.day.to_s.rjust(WIDTH_1DAY)
  if date == today # 今日の日付は色を反転する
    color_text(day, INVERT_COLOR)
  else
    color_text(day, NORMAL_COLOR)
  end
end

def year_and_month_to_text(year, month)
  year_and_month_text = "#{month}月 #{year}年"
  year_and_month_center = ' ' * ((WIDTH_CALENDER - year_and_month_text.length) / 2) + year_and_month_text
  year_and_month_center.gsub!(/\d+/) { |str| color_text(str, NORMAL_COLOR) }
end

def generate_calendar(year, month, today)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  days_unshaped = ([' ' * WIDTH_1DAY] * first_date.wday) + (first_date..last_date).map { |date| color_days(date, today) } # 初日の曜日を合わせる
  days_unshaped.each_slice(7).map { |week| week.join(' ') }.join("\n")
end

def input_to_year(input)
  year = input['y'].nil? ? Date.today.year : input['y'].to_i
  return nil unless (YEAR_MIN..YEAR_MAX).cover?(year)
  year
end

def input_to_month(input)
  month = input['m'].nil? ? Date.today.month : input['m'].to_i unless
  return nil unless (MONTH_MIN..MONTH_MAX).cover?(month)
  month
end

input = ARGV.getopts('y:', 'm:')
year = input_to_year(input)
month = input_to_month(input)
puts "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。" unless year
puts "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。" unless month
if year && month
  calendar = <<~TEXT
    #{year_and_month_to_text(year, month)}
    日 月 火 水 木 金 土
    #{generate_calendar(year, month, Date.today)}
  TEXT
  puts calendar
end
