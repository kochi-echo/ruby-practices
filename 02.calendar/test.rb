#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'my_cal'

TODAY_YEAR = Date.today.year
TODAY_MONTH = Date.today.month

SAMPLE1_YEAR = 2023
SAMPLE1_MONTH = 4
SAMPLE1_DAYS = [
  ['  '] * 6 << 1,
  (2..8).to_a,
  (9..15).to_a,
  (16..22).to_a,
  (23..29).to_a,
  [30]
].freeze

SAMPLE2_YEAR = 2021
SAMPLE2_MONTH = 8
SAMPLE2_DAYS = [
  (1..7).to_a,
  (8..14).to_a,
  (15..21).to_a,
  (22..28).to_a,
  (29..31).to_a
].freeze

# def weeks_to_color(days, today)
#   days.map do |week|
#     week.map do |day|
#       if day == '  '
#         day
#       elsif day == today
#         color_text(day.to_s.rjust(WIDTH_1DAY), INVERT_COLOR)
#       else
#         color_text(day.to_s.rjust(WIDTH_1DAY), NORMAL_COLOR)
#       end
#     end
#   end
# end

# class TestVerification < Minitest::Test
#   def test_verificate_boolean
#     (YEAR_MIN..YEAR_MAX).each do |year|
#       assert year_in_range?(year)
#     end
#     (MONTH_MIN..MONTH_MAX).each do |month|
#       assert month_in_range?(month)
#     end
#     refute year_in_range?(YEAR_MIN - 1)
#     refute year_in_range?(YEAR_MAX + 1)
#     refute month_in_range?(MONTH_MIN - 1)
#     refute month_in_range?(MONTH_MAX + 1)
#   end
# end

# class TestTodayCalender < Minitest::Test
#   def test_input_to_year_month
#     option_y_m = { 'y' => nil, 'm' => nil }
#     year, month = convert_input_to_month_year(option_y_m)
#     assert_equal TODAY_YEAR, year
#     assert_equal TODAY_MONTH, month
#   end

#   def test_year_month_to_text
#     year_month_text = convert_year_month_to_text(TODAY_YEAR, TODAY_MONTH)
#     output_text = /\e\[#{NORMAL_COLOR}m#{TODAY_MONTH}\e\[0m月 \e\[#{NORMAL_COLOR}m#{TODAY_YEAR}\e\[0m年/
#     assert_match(output_text, year_month_text)
#   end

#   def test_days_to_weeks
#     weeks = convert_days_to_weeks(TODAY_YEAR, TODAY_MONTH)
#     (1..weeks.size).map { weeks.next }
#   end
# end

# class TestSample1DateCalender < Minitest::Test
#   def test_input_to_year_month
#     option_y_m = { 'y' => nil, 'm' => nil }
#     year, month = convert_input_to_month_year(option_y_m)
#     assert_equal SAMPLE1_YEAR, year
#     assert_equal SAMPLE1_MONTH, month
#   end

#   def test_year_month_to_text
#     year_month_text = convert_year_month_to_text(SAMPLE1_YEAR, SAMPLE1_MONTH)
#     output_text = /\e\[#{NORMAL_COLOR}m#{SAMPLE1_MONTH}\e\[0m月 \e\[#{NORMAL_COLOR}m#{SAMPLE1_YEAR}\e\[0m年/
#     assert_match(output_text, year_month_text)
#   end

#   def test_days_to_weeks
#     weeks = convert_days_to_weeks(SAMPLE1_YEAR, SAMPLE1_MONTH)
#     calc_weeeks = (1..weeks.size).map { weeks.next }
#     sample1_weeks = weeks_to_color(SAMPLE1_DAYS, Date.today.day)
#     assert_equal sample1_weeks, calc_weeeks
#   end
# end

# class TestSample_to_DateCalender < Minitest::Test
#   def test_year_month_to_text
#     year_month_text = convert_year_month_to_text(SAMPLE2_YEAR, SAMPLE2_MONTH)
#     output_text = /\e\[#{NORMAL_COLOR}m#{SAMPLE2_MONTH}\e\[0m月 \e\[#{NORMAL_COLOR}m#{SAMPLE2_YEAR}\e\[0m年/
#     assert_match(output_text, year_month_text)
#   end

#   def test_days_to_weeks
#     weeks = convert_days_to_weeks(SAMPLE2_YEAR, SAMPLE2_MONTH)
#     calc_weeeks = (1..weeks.size).map { weeks.next }
#     sample2_weeks = weeks_to_color(SAMPLE2_DAYS, nil)
#     assert_equal sample2_weeks, calc_weeeks
#   end
# end

class TestInputToYearAndMonth < Minitest::Test
  def test_input_to_year_and_month
    year, month = [nil, nil]
    option_y_m = {'y' => year, 'm' => month}
    assert_equal [Date.today.year, Date.today.month], input_to_year_and_month(option_y_m)
  end
end
