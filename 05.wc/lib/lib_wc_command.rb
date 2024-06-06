#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

def run_wc(path_name, options)
  files_path = Dir.glob(path_name.join('*'))
  files_path.map do |file_path|
    io = File.open(file_path)
    content = io.read

    {
      row_number: content.lines.count,
      word_number: content.split.size,
      bytesize: content.bytesize,
      file_name: File.basename(file_path)
    }
  end
end
