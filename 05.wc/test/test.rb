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

  def test_wc_all_txt
    expected = [
      '       1       3       6 one_line.txt',
      '       3       3       9 three_lines.txt'
    ].join('\n')
    assert_equal expected, run_wc(DIRECTORY_PATHNAME + '*.txt', {})
  end

  def test_wc_one_line_file_l_option
    assert_equal '       1 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {l: true})
  end

  def test_wc_one_line_file_w_option
    assert_equal '       3 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {w: true})
  end

  def test_wc_one_line_file_c_option
    assert_equal '       6 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {c: true})
  end

  def test_wc_one_line_file_multiple_options
    assert_equal '       1       3       6 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {l: true, w: true, c: true})
    assert_equal '       1       3 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {l: true, w: true})
    assert_equal '       3       6 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {w: true, c: true})
    assert_equal '       1       6 one_line.txt', run_wc(DIRECTORY_PATHNAME + 'one_line.txt', {l: true, c: true})
  end


end
