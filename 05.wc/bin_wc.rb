#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

require_relative './lib/lib_wc_command'

options = {}
opt = OptionParser.new
opt.on('-l') { options[:a] = true }
opt.on('-w') { options[:r] = true }
opt.on('-c') { options[:l] = true }
opt.parse!(ARGV) # オプション除いて残った引数
input = ARGV[0]

path_name = Pathname(input || '.')

puts run_wc(path_name, options)
