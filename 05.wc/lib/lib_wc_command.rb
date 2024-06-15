# frozen_string_literal: true

ALL_OPTIONS = %i[l w c].freeze

def run_wc(argv, stdin, options)
  contents_numbers_and_total = argv.nil? ? [content_numbers(stdin, '')] : collect_numbers([*argv], options)
  # [*argv]はargv入力が一つのファイル指定の時str型で複数ファイル指定の時にarray型になるため
  format_texts(contents_numbers_and_total, options)
end

def collect_numbers(argvs)
  paths = argvs.flat_map { |str| Dir.glob(str) }
  # 複数ファイルが指定された場合に、入れ子の配列になるのを防ぐ ex. ['*.txt', '*.rb'] -> ['a.txt', 'b.txt', 'c.rb']
  content_numbers = paths.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    numbers = {}
    File.open(path) { |f| numbers = content_numbers(f.read, path) }
    numbers
  end
  content_numbers.size > 1 ? add_total_numbers(content_numbers) : content_numbers
end

def content_numbers(content, path)
  {
    l: content.lines.count,
    w: content.split.size,
    c: content.bytesize,
    file_name: path
  }
end

def format_texts(contents_numbers_and_total, options)
  contents_numbers_and_total.map do |content_numbers|
    next content_numbers[:warning] if content_numbers.key?(:warning)

    content_numbers.keys.map do |key|
      if key == :file_name
        " #{content_numbers[:file_name]}" unless content_numbers[:file_name].empty?
      elsif options.empty? || options[key]
        content_numbers[key].to_s.rjust(8)
      end
    end.join
  end.join("\n")
end

def add_total_numbers(content_numbers)
  total_numbers = ALL_OPTIONS.to_h do |key|
    [key, content_numbers.sum { |numbers| numbers[key] || 0 }]
  end
  total_numbers[:file_name] = 'total'
  content_numbers.push(total_numbers)
end
