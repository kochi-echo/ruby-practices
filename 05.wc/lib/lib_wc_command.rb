#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

def run_wc(path_name, options)
  files_name = Dir.glob(path_name.join('*'))
  files_name.map do |file_name|
    io = File.open(file_name)
    content = io.read
    rows = content.lines
    rows.count
  end
end
