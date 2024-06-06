#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

def run_wc(path_name, options)
  files_path = Dir.glob(path_name)
  files_data = build_data(files_path)
  align_data(files_data, options)
end

def build_data(files_path)
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

def align_data(files_data, options)
  files_data.map do |file_data|
    [
    "       #{file_data[:row_number]}",
    "       #{file_data[:word_number]}",
    "       #{file_data[:bytesize]}",
    " #{file_data[:file_name]}"
    ].join
  end.join('\n')
end
