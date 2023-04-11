#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative 'my_cal'

SAMPLE1_YEAR = 2023
SAMPLE1_MONTH = 3
SAMPLE1_DAYS_TEXT =[
["  ", "  ", "  ", " 1", " 2", " 3", " 4"],
[" 5", " 6", " 7", " 8", " 9", "10", "11"],
["12", "13", "14", "15", "16", "17", "18"],
["19", "20", "21", "22", "23", "24", "25"],
["26", "27", "28", "29", "30", "31"]
].freeze

SAMPLE2_YEAR = 2021
SAMPLE2_MONTH = 8
SAMPLE2_DAYS_TEXT =[
  [" 1", " 2", " 3", " 4", " 5", " 6", " 7"],
  [" 8", " 9", "10", "11", "12", "13", "14"],
  ["15", "16", "17", "18", "19", "20", "21"],
  ["22", "23", "24", "25", "26", "27", "28"],
  ["29", "30", "31"]
  ].freeze

class TestInputToYearAndMonth < Minitest::Test
  def test_input_nil
    option_y_m = {'y' => nil, 'm' => nil}
    assert_equal [Date.today.year, Date.today.month], input_to_year_and_month(option_y_m)
  end

  def test_input_normal
    option_y_m = {'y' => SAMPLE1_YEAR.to_s, 'm' => SAMPLE1_MONTH.to_s}
    assert_equal [SAMPLE1_YEAR, SAMPLE1_MONTH], input_to_year_and_month(option_y_m)
    option_y_m = {'y' => SAMPLE2_YEAR.to_s, 'm' => SAMPLE2_MONTH.to_s}
    assert_equal [SAMPLE2_YEAR, SAMPLE2_MONTH], input_to_year_and_month(option_y_m)
  end
end

class TestYearAndMonthInRange < Minitest::Test
  def test_input_in_range
    assert year_and_month_in_range?(YEAR_MIN, MONTH_MIN)
    assert year_and_month_in_range?(YEAR_MAX, MONTH_MAX)
  end

  def test_input_out_of_range
    year = YEAR_MIN - 1
    month = MONTH_MIN
    refute year_and_month_in_range?(year, month)
    assert_output("#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n"){ year_and_month_in_range?(year, month) }
    year = YEAR_MIN
    month = MONTH_MIN - 1
    refute year_and_month_in_range?(year, month)
    assert_output("#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n"){ year_and_month_in_range?(year, month) }
    year = YEAR_MAX + 1
    month = MONTH_MAX
    refute year_and_month_in_range?(year, month)
    assert_output("#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n"){ year_and_month_in_range?(year, month) }
    year = YEAR_MAX
    month = MONTH_MAX + 1
    refute year_and_month_in_range?(year, month)
    assert_output("#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n"){ year_and_month_in_range?(year, month) }
    year = YEAR_MAX + 1
    month = MONTH_MAX + 1
    refute year_and_month_in_range?(year, month)
    assert_output(
      "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n" +
      "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n"
      ){ year_and_month_in_range?(year, month) }
  end
end

class TestPrintCalendar < Minitest::Test
  def test_sample1_calendar
    year = SAMPLE1_YEAR
    month = SAMPLE1_MONTH
    days_text = SAMPLE1_DAYS_TEXT.map do |week|
      week.map do |day|
        day.gsub(/(\s|^)\d+/) { "\e[#{NORMAL_COLOR}m#{day.rjust(WIDTH_1DAY)}\033[0m" }
      end.join(" ")
    end.join("\n")
    assert_output(
      "#{month}月 #{year}年".center(WIDTH_CALENDER).gsub!(/\d+/) { |num| "\e[#{NORMAL_COLOR}m#{num}\033[0m" } + "\n" +
      DAY_OF_WEEKS_TEXT +
      days_text +
      "\n"
    ){ print_calendar(year, month) }
  end
  
  def test_sample2_calendar
    year = SAMPLE2_YEAR
    month = SAMPLE2_MONTH
    days_text = SAMPLE2_DAYS_TEXT.map do |week|
      week.map do |day|
        day.gsub(/(\s|^)\d+/) { "\e[#{NORMAL_COLOR}m#{day.rjust(WIDTH_1DAY)}\033[0m" }
      end.join(" ")
    end.join("\n")
    assert_output(
      "#{month}月 #{year}年".center(WIDTH_CALENDER).gsub!(/\d+/) { |num| "\e[#{NORMAL_COLOR}m#{num}\033[0m" } + "\n" +
      DAY_OF_WEEKS_TEXT +
      days_text +
      "\n"
    ){ print_calendar(year, month) }
  end
end
