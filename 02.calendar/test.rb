#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'my_cal'

SAMPLE1_YEAR = 2023
SAMPLE1_MONTH = 4
SAMPLE1_TODAY = 10
SAMPLE1_CALENDAR = (
    "      \e[38;5;208m4\033[0m月 \e[38;5;208m2023\033[0m年      \n" +
    # "      \e[38;5;208m4\033[0m月 \e[38;5;208m2023\033[0m年\n" +
    DAY_OF_WEEKS_TEXT +
    ' ' * 18 + "\e[38;5;208m 1\033[0m\n" +
    "\e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m \e[38;5;208m 8\033[0m\n" +
    "\e[38;5;208m 9\033[0m \e[7m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m \e[38;5;208m15\033[0m\n" +
    "\e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[38;5;208m20\033[0m \e[38;5;208m21\033[0m \e[38;5;208m22\033[0m\n" +
    "\e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m \e[38;5;208m29\033[0m\n" +
    "\e[38;5;208m30\033[0m\n"
  )

SAMPLE2_YEAR = 2021
SAMPLE2_MONTH = 8
SAMPLE2_TODAY = 20
SAMPLE2_CALENDAR = (
    "      \e[38;5;208m8\033[0m月 \e[38;5;208m2021\033[0m年      \n" +
    DAY_OF_WEEKS_TEXT +
    "\e[38;5;208m 1\033[0m \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m\n" +
    "\e[38;5;208m 8\033[0m \e[38;5;208m 9\033[0m \e[38;5;208m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m\n" +
    "\e[38;5;208m15\033[0m \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[7m20\033[0m \e[38;5;208m21\033[0m\n" +
    "\e[38;5;208m22\033[0m \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m\n" +
    "\e[38;5;208m29\033[0m \e[38;5;208m30\033[0m \e[38;5;208m31\033[0m\n"
  )

class TestInputToYearAndMonth < Minitest::Test
  def test_input_nil
    option_y_m = { 'y' => nil, 'm' => nil }
    assert_equal [Date.today.year, Date.today.month], input_to_year_and_month(option_y_m)
  end

  def test_input_normal
    option_y_m = { 'y' => SAMPLE1_YEAR.to_s, 'm' => SAMPLE1_MONTH.to_s }
    assert_equal [SAMPLE1_YEAR, SAMPLE1_MONTH], input_to_year_and_month(option_y_m)
    option_y_m = { 'y' => SAMPLE2_YEAR.to_s, 'm' => SAMPLE2_MONTH.to_s }
    assert_equal [SAMPLE2_YEAR, SAMPLE2_MONTH], input_to_year_and_month(option_y_m)
  end
end

class TestYearAndMonthInRange < Minitest::Test
  def test_year_in_range
    assert_equal '', generate_text_year_in_range(YEAR_MIN)
    assert_equal '', generate_text_year_in_range(YEAR_MAX)
  end

  def test_month_in_range
    assert_equal '', generate_text_month_in_range(MONTH_MIN)
    assert_equal '', generate_text_month_in_range(MONTH_MAX)
  end

  def test_year_out_range
    year = YEAR_MIN - 1
    assert_equal "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n", generate_text_year_in_range(year)
    year = YEAR_MAX + 1
    assert_equal "#{year}年は規定値#{YEAR_MIN}〜#{YEAR_MAX}年の範囲外です。\n", generate_text_year_in_range(year)
  end

  def test_month_out_range
    month = MONTH_MIN - 1
    assert_equal "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n", generate_text_month_in_range(month)
    month = MONTH_MAX + 1
    assert_equal "#{month}月は規定値#{MONTH_MIN}〜#{MONTH_MAX}月の範囲外です。\n", generate_text_month_in_range(month)
  end
end

class TestPrintCalendar < Minitest::Test
  def test_sample1_calendar
    year = SAMPLE1_YEAR
    month = SAMPLE1_MONTH
    today = Date.new(year, month, SAMPLE1_TODAY)
    assert_equal SAMPLE1_CALENDAR, summarize_calendar(year, month, today)
  end

  def test_sample2_calendar
    year = SAMPLE2_YEAR
    month = SAMPLE2_MONTH
    today = Date.new(year, month, SAMPLE2_TODAY)
    assert_equal SAMPLE2_CALENDAR, summarize_calendar(year, month, today)
  end
end
