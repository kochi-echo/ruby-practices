require'minitest/autorun'
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

def weeks2color(days, today)
  sample_weeks = days.map do |week|
    week.map do |day|
      if day == '  '
        day
      elsif day == today
        color_text(day.to_s.rjust(2), INVERT_COLOR)
      else 
        color_text(day.to_s.rjust(2), NORMAL_COLOR)
      end
    end
  end
  sample_weeks
end

class TestVerification < Minitest::Test
  def test_verificate_boolean
    (YEAR_MIN..YEAR_MAX).each do |year|
      assert year_in_range?(year)
    end
    (MONTH_MIN..MONTH_MAX).each do |month|
      assert month_in_range?(month)
    end
    refute year_in_range?(YEAR_MIN - 1)
    refute year_in_range?(YEAR_MAX + 1)
    refute month_in_range?(MONTH_MIN - 1)
    refute month_in_range?(MONTH_MAX + 1)
  end
end

class TestTodayCalender < Minitest::Test
  def test_input2year_month
    option_y_m = {'y' => nil, 'm' => nil}
    year, month = convert_input2month_year(option_y_m)
    assert_equal TODAY_YEAR, year
    assert_equal TODAY_MONTH, month
  end
  def test_year_month2text
    year_month_text = year_month2text(TODAY_YEAR, TODAY_MONTH)
    assert_match /#{TODAY_MONTH}/, year_month_text
    assert_match /#{TODAY_YEAR}/, year_month_text
    assert_equal year_month_text.center(WIDTH_CALENDER), year_month_text
    assert_match /\e\[38;5;208m#{TODAY_MONTH}\033\[0m/, year_month_text
    assert_match /\e\[38;5;208m#{TODAY_YEAR}\033\[0m/, year_month_text
  end
  def test_days2weeks
    weeks = days2weeks(TODAY_YEAR, TODAY_MONTH)
    weeeks_text = (1..weeks.size).map { weeks.next }
  end
end

class TestSampleDateCalender < Minitest::Test
  def test_input2year_month
    option_y_m = {'y' => nil, 'm' => nil}
    year, month = convert_input2month_year(option_y_m)
    assert_equal SAMPLE1_YEAR, year
    assert_equal SAMPLE1_MONTH, month
  end
  def test_year_month2text
    year_month_text = year_month2text(SAMPLE1_YEAR, SAMPLE1_MONTH)
    assert_match /#{SAMPLE1_MONTH}/, year_month_text
    assert_match /#{SAMPLE1_YEAR}/, year_month_text
    assert_equal year_month_text.center(WIDTH_CALENDER), year_month_text
    assert_match /\e\[38;5;208m#{SAMPLE1_MONTH}\033\[0m/, year_month_text
    assert_match /\e\[38;5;208m#{SAMPLE1_YEAR}\033\[0m/, year_month_text
  end
  def test_days2weeks
    weeks = days2weeks(SAMPLE1_YEAR, SAMPLE1_MONTH)
    calc_weeeks = (1..weeks.size).map { weeks.next }
    sample1_weeks = weeks2color(SAMPLE1_DAYS, Date.today.day)
    ssert_equal sample1_weeks, calc_weeeks
  end
end

class TestSampleDateCalender < Minitest::Test
  def test_year_month2text
    year_month_text = year_month2text(SAMPLE2_YEAR, SAMPLE2_MONTH)
    assert_match /#{SAMPLE2_MONTH}/, year_month_text
    assert_match /#{SAMPLE2_YEAR}/, year_month_text
    assert_equal year_month_text.center(WIDTH_CALENDER), year_month_text
    assert_match /\e\[38;5;208m#{SAMPLE2_MONTH}\033\[0m/, year_month_text
    assert_match /\e\[38;5;208m#{SAMPLE2_YEAR}\033\[0m/, year_month_text
  end
  def test_days2weeks
    weeks = days2weeks(SAMPLE2_YEAR, SAMPLE2_MONTH)
    calc_weeeks = (1..weeks.size).map { weeks.next }
    sample2_weeks = weeks2color(SAMPLE2_DAYS, nil)
    assert_equal sample2_weeks, calc_weeeks
  end
end


