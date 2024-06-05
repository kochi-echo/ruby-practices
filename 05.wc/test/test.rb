#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/bin_wc'

class WCTest < Minitest::Test
  def test_wc_without_argument
    '       1       3       6 one_line.txt'
  end
end
