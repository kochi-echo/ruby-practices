#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/lib_wc_command'

class WCTest < Minitest::Test
  TARGET_PATHNAME = Pathname('./05.wc/test/test_target')

  def test_wc_without_argument
    assert_equal '       1       3       6 one_line.txt', run_wc(TARGET_PATHNAME, {})
  end
end
