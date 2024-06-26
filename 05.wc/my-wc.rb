#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './lib/lib_wc_command'

options = {}
opt = OptionParser.new
opt.on('-l') { options[:l] = true }
opt.on('-w') { options[:w] = true }
opt.on('-c') { options[:c] = true }
opt.parse!(ARGV) # オプション除いて残った引数

stdin = $stdin.readlines.join

puts run_wc(ARGV, stdin, options)
