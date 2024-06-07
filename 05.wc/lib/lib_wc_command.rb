#!/usr/bin/env ruby
# frozen_string_literal: true

def run_wc(inputs, options, input_type_argv)
  files_data = collect_files_data(inputs, input_type_argv)
  display_keys = select_display_keys(options)
  text = format_data(files_data, display_keys)
  text.push(format_total(files_data, display_keys)) if files_data.size > 1
  text.join("\n")
end

def collect_files_data(inputs, input_type_argv)
  if input_type_argv
    paths = inputs.flat_map { |input| Dir.glob(input) }
    build_data(paths)
  else
    [file_data(inputs, '')]
  end
end

def select_display_keys(options)
  no_option = options.values.none?
  {
    row_number: no_option || options[:l],
    word_number: no_option || options[:w],
    bytesize: no_option || options[:c]
  }.select { |_key, value| value }.keys
end

def build_data(paths)
  paths.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    file = File.open(path)
    content = file.read
    file_data(content, path)
  end
end

def file_data(content, path)
  {
    row_number: content.lines.count,
    word_number: content.split.size,
    bytesize: content.bytesize,
    file_name: path
  }
end

def format_data(files_data, display_keys)
  files_data.map do |file_data|
    next file_data[:warning] if file_data.key?(:warning)

    text = display_keys.map { |key| file_data[key].to_s.rjust(8) }
    text.push(" #{file_data[:file_name]}") unless file_data[:file_name].empty?
    text.join
  end
end

def format_total(files_data, display_keys)
  text = display_keys.map do |key|
    files_data.sum { |file_data| file_data.key?(key) ? file_data[key] : 0 }.to_s.rjust(8)
  end
  text.push(' total').join
end
