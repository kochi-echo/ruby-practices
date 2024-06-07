#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/lib_wc_command'

class WCTest < Minitest::Test
  def test_wc_one_line_file
    assert_equal '       1       3       6 ./05.wc/test/test_target/test_dir/one_line.txt', run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], {}, true)
  end

  def test_wc_3_lines_file
    assert_equal '       3       3       9 ./05.wc/test/test_target/test_dir/three_lines.txt',
                 run_wc(['./05.wc/test/test_target/test_dir/three_lines.txt'], {}, true)
  end

  def test_wc_all_txt
    expected = [
      '       1       3       6 ./05.wc/test/test_target/test_dir/one_line.txt',
      '       3       3       9 ./05.wc/test/test_target/test_dir/three_lines.txt',
      '       4       6      15 total'
    ].join("\n")
    assert_equal expected, run_wc(['./05.wc/test/test_target/test_dir/*.txt'], {}, true)
  end

  def test_wc_two_files
    expected = [
      '       1       3       6 ./05.wc/test/test_target/test_dir/one_line.txt',
      '       2       3      19 ./05.wc/test/test_target/test_dir/two_lines.md',
      '       3       6      25 total'
    ].join("\n")
    assert_equal expected, run_wc(['./05.wc/test/test_target/test_dir/one_line.txt', './05.wc/test/test_target/test_dir/two_lines.md'], {}, true)
  end

  def test_wc_all_files
    expected = [
      '       1       3       6 ./05.wc/test/test_target/test_dir/one_line.txt',
      '       3       3       9 ./05.wc/test/test_target/test_dir/three_lines.txt',
      '       2       3      19 ./05.wc/test/test_target/test_dir/two_lines.md',
      '       6       9      34 total'
    ].join("\n")
    assert_equal expected, run_wc(['./05.wc/test/test_target/test_dir/*'], {}, true)
  end

  def test_wc_one_line_file_l_option
    assert_equal '       1 ./05.wc/test/test_target/test_dir/one_line.txt', run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { l: true }, true)
  end

  def test_wc_one_line_file_w_option
    assert_equal '       3 ./05.wc/test/test_target/test_dir/one_line.txt', run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { w: true }, true)
  end

  def test_wc_one_line_file_c_option
    assert_equal '       6 ./05.wc/test/test_target/test_dir/one_line.txt', run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { c: true }, true)
  end

  def test_wc_one_line_file_multiple_options
    assert_equal '       1       3       6 ./05.wc/test/test_target/test_dir/one_line.txt',
                 run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { l: true, w: true, c: true }, true)
    assert_equal '       1       3 ./05.wc/test/test_target/test_dir/one_line.txt',
                 run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { l: true, w: true }, true)
    assert_equal '       3       6 ./05.wc/test/test_target/test_dir/one_line.txt',
                 run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { w: true, c: true }, true)
    assert_equal '       1       6 ./05.wc/test/test_target/test_dir/one_line.txt',
                 run_wc(['./05.wc/test/test_target/test_dir/one_line.txt'], { l: true, c: true }, true)
  end

  def test_wc_warning
    expected = [
      'wc: ./05.wc/test/test_target/test_dir: read: Is a directory',
      '       2       3      15 ./05.wc/test/test_target/three_word.md',
      '       2       3      15 total'
    ].join("\n")
    assert_equal expected, run_wc(['./05.wc/test/test_target/*'], {}, true)
  end

  def test_stdin
    assert_equal '       3       3      42', run_wc("one_line.txt\nthree_lines.txt\ntwo_lines.md\n", {}, false)
  end
end
