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
    option_y_m = { 'y' => '2023', 'm' => '4' }
    assert_equal [2023, 4], input_to_year_and_month(option_y_m)
    option_y_m = { 'y' => '2021', 'm' => '8' }
    assert_equal [2021, 8], input_to_year_and_month(option_y_m)
  end
end

class TestPrintCalendar < Minitest::Test
  def test_year_and_month_text
    assert_equal "\      \e[38;5;208m4\033[0m月 \e[38;5;208m2023\033[0m年", year_and_month_to_text(2023, 4)
    assert_equal "\      \e[38;5;208m8\033[0m月 \e[38;5;208m2021\033[0m年", year_and_month_to_text(2021, 8)
  end

  def test_saturday_start_calendar
    calendar = <<~TEXT.chomp
      \                  \e[38;5;208m 1\033[0m
      \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m \e[38;5;208m 8\033[0m
      \e[38;5;208m 9\033[0m \e[7m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m \e[38;5;208m15\033[0m
      \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[38;5;208m20\033[0m \e[38;5;208m21\033[0m \e[38;5;208m22\033[0m
      \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m \e[38;5;208m29\033[0m
      \e[38;5;208m30\033[0m
    TEXT
    today = Date.new(2023, 4, 10)
    assert_equal calendar, generate_calendar(2023, 4, today)
  end

  def test_sunday_start_calendar
    calendar = <<~TEXT.chomp
      \e[38;5;208m 1\033[0m \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m
      \e[38;5;208m 8\033[0m \e[38;5;208m 9\033[0m \e[38;5;208m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m
      \e[38;5;208m15\033[0m \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m \e[7m20\033[0m \e[38;5;208m21\033[0m
      \e[38;5;208m22\033[0m \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m
      \e[38;5;208m29\033[0m \e[38;5;208m30\033[0m \e[38;5;208m31\033[0m
    TEXT
    today = Date.new(2021, 8, 20)
    assert_equal calendar, generate_calendar(2021, 8, today)
  end

  def test_leap_year_calendar
    calendar = <<~TEXT.chomp
      \      \e[38;5;208m 1\033[0m \e[38;5;208m 2\033[0m \e[38;5;208m 3\033[0m \e[38;5;208m 4\033[0m \e[38;5;208m 5\033[0m
      \e[38;5;208m 6\033[0m \e[38;5;208m 7\033[0m \e[38;5;208m 8\033[0m \e[38;5;208m 9\033[0m \e[38;5;208m10\033[0m \e[38;5;208m11\033[0m \e[38;5;208m12\033[0m
      \e[38;5;208m13\033[0m \e[38;5;208m14\033[0m \e[38;5;208m15\033[0m \e[38;5;208m16\033[0m \e[38;5;208m17\033[0m \e[38;5;208m18\033[0m \e[38;5;208m19\033[0m
      \e[38;5;208m20\033[0m \e[38;5;208m21\033[0m \e[38;5;208m22\033[0m \e[38;5;208m23\033[0m \e[38;5;208m24\033[0m \e[38;5;208m25\033[0m \e[38;5;208m26\033[0m
      \e[38;5;208m27\033[0m \e[38;5;208m28\033[0m \e[7m29\033[0m
    TEXT
    today = Date.new(2000, 2, 29)
    assert_equal calendar, generate_calendar(2000, 2, today)
  end
end
