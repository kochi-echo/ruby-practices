#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

def run_wc(path, options)
  targets_path = Dir.glob(path)
  files_data = build_data(targets_path)
  align_data(files_data, options)
end

def build_data(targets_path)
  targets_path.map do |file_path|
    next if File.directory?(file_path)
    io = File.open(file_path)
    content = io.read

    {
      row_number: content.lines.count,
      word_number: content.split.size,
      bytesize: content.bytesize,
      file_name: File.basename(file_path)
    }
  end.compact
end

def align_data(files_data, options)
  files_data.map do |file_data|
    no_option = options.values.count(true).zero?
    text = []
    text.push("       #{file_data[:row_number]}") if no_option || options[:l]
    text.push("       #{file_data[:word_number]}") if no_option || options[:w]
    text.push("       #{file_data[:bytesize]}") if no_option || options[:c]
    text.push(" #{file_data[:file_name]}")
    text.join
  end.join('\n')
end
