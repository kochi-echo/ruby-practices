#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'my_cal'

class TestInputToYearAndMonth < Minitest::Test
  def test_input_nil
    option_y_m = { 'y' => nil, 'm' => nil }
    assert_equal [Date.today.year, Date.today.month], input_to_year_and_month(option_y_m)
  end

  def test_input_normal
    year = 2023
    month = 4
    option_y_m = { 'y' => year.to_s, 'm' => month.to_s }
    assert_equal [year, month], input_to_year_and_month(option_y_m)
    year = 2021
    month = 8
    option_y_m = { 'y' => year.to_s, 'm' => month.to_s }
    assert_equal [year, month], input_to_year_and_month(option_y_m)
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
    calendar = <<~TEXT
      \      \e[38;5;208m4\033[0m月 \e[38;5;208m2023\033[0m年
      日 月 火 水 木 金 土
                        \e[38;5;208m 1\033[0m
      \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m \e[38;5;208m 8\033[0m
      \e[38;5;208m 9\033[0m \e[7m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m \e[38;5;208m15\033[0m
      \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[38;5;208m20\033[0m \e[38;5;208m21\033[0m \e[38;5;208m22\033[0m
      \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m \e[38;5;208m29\033[0m
      \e[38;5;208m30\033[0m
    TEXT
    today = Date.new(2023, 4, 10)
    assert_equal calendar, summarize_calendar(2023, 4, today)
  end

  def test_sample2_calendar
    calendar = <<~TEXT
      \      \e[38;5;208m8\033[0m月 \e[38;5;208m2021\033[0m年
      日 月 火 水 木 金 土
      \e[38;5;208m 1\033[0m \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m
      \e[38;5;208m 8\033[0m \e[38;5;208m 9\033[0m \e[38;5;208m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m
      \e[38;5;208m15\033[0m \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[7m20\033[0m \e[38;5;208m21\033[0m
      \e[38;5;208m22\033[0m \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m
      \e[38;5;208m29\033[0m \e[38;5;208m30\033[0m \e[38;5;208m31\033[0m
    TEXT
    today = Date.new(2021, 8, 20)
    assert_equal calendar, summarize_calendar(2021, 8, today)
  end
end
