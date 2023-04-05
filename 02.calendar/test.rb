require'minitest/autorun'
require_relative 'my_cal'

TODAY_YEAR = Date.today.year
TODAY_MONTH = Date.today.month

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
end
