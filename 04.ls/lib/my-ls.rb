#!/usr/bin/env ruby
# frozen_string_literal: true

LIST_ROW_NUM = 3

class Array
  def divide_equal(number)
    split_num = (self.size / number.to_f).ceil
    self.each_slice(split_num).to_a
  end

  def transpose_lack # Array#teansposeとは異なり、二次元配列の要素のサイズが異なっても転置できるメソッド
    max_size = self.map(&:size).max
    (0...max_size).map do |selection_num|
      self.map { |nest_array| nest_array[selection_num] }.compact
    end
  end

  def sort_jp # Array#sortとは異なり、漢字→ひらがな→カタカナの順にソートするメソッド
    self.sort do |a, b|
      if a.match?(/\p{Han}/) &&  b.match?(/\p{Han}|\p{Hiragana}|\p{Katakana}/)
        -1
      elsif a.match?(/\p{Han}|\p{Hiragana}|\p{Katakana}/) && b.match?(/\p{Han}/)
        1
      else
        a <=> b
      end
    end
  end
end

class String
  def size_jp # String#sizeと異なり、日本語を2文字とみなすメソッド
    count = 0
    self.each_char do |char|
      if char.match?(/\p{Han}|\p{Hiragana}|\p{Katakana}|ー/)
        count += 2
      else
        count += 1
      end
    end
    count
  end

  def ljust_jp(max_size)
    self + ' ' * (max_size - self.size_jp)
  end
end

def get_file_names(argument_name)
  argument_name ||= '.'
  absolute_path = File.expand_path(argument_name)
  target_dir, target_file = path_to_directory_and_file(absolute_path)
  select_file(target_dir, target_file)
end

def path_to_directory_and_file(absolute_path)
  if File.file?(absolute_path)
    target_dir = File.dirname(absolute_path)
    target_file = File.basename(absolute_path)
  else
    target_dir = absolute_path
    target_file = ''
  end
  [target_dir, target_file]
end

def select_file(target_dir, target_file)
  file_names_all = Dir.entries(target_dir).map(&:unicode_normalize).sort_jp # String#unicode_normalizeしないとsortや文字カウントがズレる
  
  if target_file.empty?
    file_names_all.reject { |file_name| file_name =~ /^\./ } # '.', '..', '.ファイル名'を除外する
  else
    file_names_all.select{ |file_name| file_name == target_file} # '.ファイル名'も表示対象
  end  
end

def generate_name_list_text(file_names, number)
  separatiopn_names = file_names.divide_equal(number)
  max_name_size = file_names.max {|a, b| a.size_jp <=> b.size_jp }.size_jp

  separatiopn_names.transpose_lack.inject('') do |text, names|
    text += names.map.with_index(1) do |name, index| 
      index < names.size ? name.ljust_jp(max_name_size) : name # 行末はファイル名の右側にスペースを入れない
    end.join(' ') + "\n"
  end
end

input = ARGV[0]
file_names = get_file_names(input)
print generate_name_list_text(file_names, LIST_ROW_NUM)
