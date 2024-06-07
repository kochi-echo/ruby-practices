#!/usr/bin/env ruby
# frozen_string_literal: true

def run_wc(inputs, options, input_type_argv)
  files_data = files_data(inputs, input_type_argv)
  display_selection = display_selection(options)
  text = align_data(files_data, display_selection)
  text.push(calculate_total(files_data, display_selection)) if files_data.size > 1
  text.join("\n")
end

def files_data(inputs, input_type_argv)
  if input_type_argv
    targets_path = inputs.map { |input| Dir.glob(input) }.flatten
    build_data(targets_path)
  else
    [file_data(inputs, '')]
  end
end

def display_selection(options)
  no_option = options.values.count(true).zero?
  {
    row_number: no_option || options[:l],
    word_number: no_option || options[:w],
    bytesize: no_option || options[:c]
  }.select { |_key, value| value }.keys
end

def build_data(targets_path)
  targets_path.map do |target_path|
    next { warning: "wc: #{target_path}: read: Is a directory" } if File.directory?(target_path)

    io = File.open(target_path)
    content = io.read
    file_data(content, target_path)
  end.compact
end

def file_data(content, target_path)
  {
    row_number: content.lines.count,
    word_number: content.split.size,
    bytesize: content.bytesize,
    file_name: target_path
  }
end

def align_data(files_data, display_selection)
  files_data.map do |file_data|
    next file_data[:warning] if file_data.key?(:warning)

    text = display_selection.map { |key| file_data[key].to_s.rjust(8) }
    text.push(" #{file_data[:file_name]}") unless file_data[:file_name].empty?
    text.join
  end
end

def calculate_total(files_data, display_selection)
  text = display_selection.map do |key|
    files_data.sum { |file_data| file_data.key?(key) ? file_data[key] : 0 }.to_s.rjust(8)
  end
  text.push(' total').join
end
