# frozen_string_literal: true

def run_wc(argv, stdin, options)
  contents_numbers_and_total = argv.nil? ? [content_numbers(stdin, '')] : collect_numbers([*argv])
  # [*argv]はargv入力が一つのファイル指定の時str型で複数ファイル指定の時にarray型になるため
  format_texts(contents_numbers_and_total, options)
end

def collect_numbers(argvs)
  paths = argvs.flat_map { |str| Dir.glob(str) }
  # 複数ファイルが指定された場合に、入れ子の配列になるのを防ぐ ex. ['*.txt', '*.rb'] -> ['a.txt', 'b.txt', 'c.rb']
  contents_numbers = paths.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    File.open(path) { |f| content_numbers(f.read, path) }
  end
  contents_numbers.size > 1 ? add_total_numbers(contents_numbers) : contents_numbers
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
  options = {l: true, w: true, c: true} if options.empty?

  contents_numbers_and_total.map do |content_numbers|
    next content_numbers[:warning] if content_numbers.key?(:warning)

    content_numbers.map do |key, value|
      if key == :file_name && !value.empty?
        " #{value}"
      elsif options[key]
        value.to_s.rjust(8)
      end
    end.join
  end.join("\n")
end

def add_total_numbers(contents_numbers)
  total_numbers = contents_numbers.each_with_object({l: 0, w: 0, c: 0, file_name: 'total'}) do |numbers, total_numbers|
    numbers.each do |key, value|
      total_numbers[key] += value || 0 if [:l, :w, :c].include?(key)
    end
  end
  contents_numbers.push(total_numbers)
end
