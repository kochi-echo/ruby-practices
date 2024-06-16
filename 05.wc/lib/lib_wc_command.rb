# frozen_string_literal: true

def run_wc(argv, stdin, options)
  contents = argv.nil? ? [{numbers: numbers(stdin)}] : collect_contents([*argv])
  # [*argv]はargv入力が一つのファイル指定の時str型で複数ファイル指定の時にarray型になるため
  format_texts(contents, options)
end

def collect_contents(argvs)
  paths = argvs.flat_map { |str| Dir.glob(str) }
  # 複数ファイルが指定された場合に、入れ子の配列になるのを防ぐ ex. ['*.txt', '*.rb'] -> ['a.txt', 'b.txt', 'c.rb']
  contents = paths.map do |path|
    next { warning: "wc: #{path}: read: Is a directory" } if File.directory?(path)

    File.open(path) { |f| {numbers: numbers(f.read), file_name: path} }
  end
  contents.size > 1 ? add_total(contents) : contents
end

def numbers(str)
  {
    l: str.lines.count,
    w: str.split.size,
    c: str.bytesize,
  }
end

def format_texts(contents, options)
  options = { l: true, w: true, c: true } if options.empty?

  contents.map do |content|
    next content[:warning] if content.key?(:warning)

    text = content[:numbers].map{ |key,value| value.to_s.rjust(8) if options[key] }
    text.push(" #{content[:file_name]}") unless content[:file_name].nil?
    text.join
  end.join("\n")
end

def add_total(contents)
  total_numbers = contents.each_with_object(Hash.new(0)) do |content, total|
    next unless content[:numbers]

    content[:numbers].each do |key, value|
      total[key] += value
    end
  end
  contents.push({numbers: total_numbers, file_name: 'total'})
end
