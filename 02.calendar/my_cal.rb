#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

NORMAL_COLOR = '38;5;208' # オレンジ
INVERT_COLOR = '7' # 白
DAY_OF_WEEKS_TEXT = "日 月 火 水 木 金 土\n"
MONTH_MIN = 1
MONTH_MAX = 12
YEAR_MIN = 1970
YEAR_MAX = 2100
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
  year_month_text = "#{"#{month}月 #{year}年".center(WIDTH_CALENDER)}\n"
  year_month_text.gsub!(/\d+/) { |str| color_text(str, NORMAL_COLOR) }
end

def days_to_weeks(year, month, today)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  days_unshaped = ([' ' * WIDTH_1DAY] * first_date.wday) + (first_date..last_date).map { |date| color_days(date, today) } # 初日の曜日を合わせる
  days_unshaped.each_slice(7).map { |week| week.join(' ') }.join("\n")
end

def summarize_calendar(year, month, today)
  (year_and_month_to_text(year, month) +
  DAY_OF_WEEKS_TEXT +
  days_to_weeks(year, month, today) + "\n")
end

def input_to_year_and_month(option_y_m)
  option_y = option_y_m['y']
  option_m = option_y_m['m']
  year = option_y.nil? ? Date.today.year : option_y.to_i
  month = option_m.nil? ? Date.today.month : option_m.to_i
  [year, month]
end

def generate_text_year_in_range(year)
  if (YEAR_MIN..YEAR_MAX).cover?(year)
    ''
  else
    "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n"
  end
end

def generate_text_month_in_range(month)
  if (MONTH_MIN..MONTH_MAX).cover?(month)
    ''
  else
    "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n"
  end
end

option_y_m = ARGV.getopts('y:', 'm:')
year, month = input_to_year_and_month(option_y_m)
text_year_in_range = generate_text_year_in_range(year)
text_month_in_range = generate_text_month_in_range(month)
print text_year_in_range unless text_year_in_range.empty?
print text_month_in_range unless text_month_in_range.empty?
print summarize_calendar(year, month, Date.today) if text_year_in_range.empty? && text_month_in_range.empty?
