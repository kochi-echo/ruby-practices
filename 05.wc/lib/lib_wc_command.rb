#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

def run_wc(inputs, options)
  targets_path = inputs.map { |input| Dir.glob(input) }.flatten
  files_data = build_data(targets_path)
  text = align_data(files_data, options)
  text.push(calculate_total(files_data, options)) if files_data.size > 1
  text.join("\n")
end

def build_data(targets_path)
  targets_path.map do |target_path|
    next { warning: "wc: #{target_path}: read: Is a directory" } if File.directory?(target_path)

    io = File.open(target_path)
    content = io.read

    {
      row_number: content.lines.count,
      word_number: content.split.size,
      bytesize: content.bytesize,
      file_name: target_path
    }
  end.compact
end

def align_data(files_data, options)
  files_data.map do |file_data|
    next file_data[:warning] if file_data.key?(:warning)

    no_option = options.values.count(true).zero?
    text = []
    text.push("#{file_data[:row_number]}".rjust(8)) if no_option || options[:l]
    text.push("#{file_data[:word_number]}".rjust(8)) if no_option || options[:w]
    text.push("#{file_data[:bytesize]}".rjust(8)) if no_option || options[:c]
    text.push(" #{file_data[:file_name]}")
    text.join
  end
end

def calculate_total(files_data, options)
  no_option = options.values.count(true).zero?
  text = []
  text.push("#{files_data.sum { |file_data| file_data.key?(:row_number) ? file_data[:row_number] : 0 }}".rjust(8)) if no_option || options[:l]
  text.push("#{files_data.sum { |file_data| file_data.key?(:word_number) ? file_data[:word_number] : 0 }}".rjust(8)) if no_option || options[:w]
  text.push("#{files_data.sum { |file_data| file_data.key?(:bytesize) ? file_data[:bytesize] : 0 }}".rjust(8)) if no_option || options[:c]
  text.push(" total").join
end
