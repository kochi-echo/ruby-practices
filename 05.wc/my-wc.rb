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
inputs = [*ARGV]

input_type_argv = inputs.empty? ? false : true

inputs = $stdin.readlines.join unless input_type_argv

puts run_wc(inputs || '.', options, input_type_argv)
