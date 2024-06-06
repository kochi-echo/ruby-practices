#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/lib_wc_command'

class WCTest < Minitest::Test
  DIRECTORY_PATHNAME = Pathname('./05.wc/test/test_target')

  def test_wc_one_line_file
    assert_equal '       1       3       6 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {})
  end

  def test_wc_3_lines_file
    assert_equal '       3       3       9 three_lines.txt', run_wc(DIRECTORY_PATHNAME + 'three_lines.txt', {})
  end
end
