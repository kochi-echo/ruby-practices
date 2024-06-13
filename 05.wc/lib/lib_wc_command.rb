# frozen_string_literal: true

def run_wc(argv, stdin, option)
  contents_numbers = argv.empty? ? [content_numbers(stdin, '')] : collect_numbers(argv)
  display_keys = select_display_keys(options)
  texts = format_texts(contents_numbers, display_keys)
  texts.join("\n")
end

def collect_numbers(argv)
  argv.flat_map { |str| Dir.glob(str) }.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    file = File.open(path)
    content = file.read
    content_numbers(content, path)
  end
end

def select_display_keys(options)
  numbers_type = { row_number: options[:l], word_number: options[:w], bytesize: options[:c]}
  options.values.none? ? numbers_type.select { |_key, value| value }.keys : numbers_type.keys
end

def content_numbers(content, path)
  {
    row_number: content.lines.count,
    word_number: content.split.size,
    bytesize: content.bytesize,
    file_name: path
  }
end

def format_texts(contents_numbers, display_keys)
  total_numbers = display_keys.to_h { |key| [key, 0] }
  lines_texts = contents_numbers.map do |content_numbers|
    next content_numbers[:warning] if content_numbers.key?(:warning)

    texts_content_numbers(content_numbers, display_keys)
  end
  lines_texts.push("#{total_numbers.values.map{ |value| value.to_s.rjust(8) }.join} total") if contents_numbers.size > 1
  lines_texts.push("\n")
end

def texts_content_numbers(content_numbers, display_keys)
  texts = display_keys.map do |key|
    num = content_numbers[key]
    total_numbers[key] += num
    num.to_s.rjust(8)
  end
  texts.push(" #{content_numbers[:file_name]}") unless file[:file_name].empty?
  texts.join
end
