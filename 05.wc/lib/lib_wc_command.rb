# frozen_string_literal: true

def run_wc(argv, stdin, options)
  contents_numbers = argv.nil? ? [content_numbers(stdin, '')] : collect_numbers([*argv]) # [*argv]は一つのファイルと複数ファイル指定した時の両方に対応するため
  display_keys = select_display_keys(options)
  format_texts(contents_numbers, display_keys)
end

def collect_numbers(argvs)
  paths = argvs.flat_map { |str| Dir.glob(str) } # 複数ファイルが指定された場合に、入れ子の配列になるのを防ぐ ex. ['*.txt', '*.rb']
  paths.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    file = File.open(path)
    content = file.read
    content_numbers(content, path)
  end
end

def select_display_keys(options)
  numbers_type = { row_number: options[:l], word_number: options[:w], bytesize: options[:c]}
  options.values.none? ? numbers_type.keys : numbers_type.select { |_key, value| value }.keys
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
  contents_numbers = add_total_numbers(contents_numbers, display_keys) if contents_numbers.size > 1

  contents_numbers.map do |content_numbers|
    next content_numbers[:warning] if content_numbers.key?(:warning)

    text = content_numbers.values_at(*display_keys).map{ |num| num.to_s.rjust(8) }
    text = " #{content_numbers[:file_name]}" unless content_numbers[:file_name].empty?
    text.join
  end.join("\n")
end

def add_total_numbers(contents_numbers, display_keys)
  total_numbers = display_keys.to_h do |key|
    [key, contents_numbers.sum { |numbers| numbers[key] }]
  end
  total_numbers[:file_name] = 'total'
  contents_numbers.push(total_numbers)
end
