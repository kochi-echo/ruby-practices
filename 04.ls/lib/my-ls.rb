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
    self.map { |element| element + [nil] * (max_size - element.size) }.transpose.map(&:compact)
  end

  def sort_jp # Array#sortとは異なり、漢字→ひらがな→カタカナの順にソートするメソッド
    self.sort do |a, b|
      if a.match?(/\p{Han}/) &&  b.match?(/\p{Hiragana}|\p{Katakana}/)
        -1
      elsif a.match?(/\p{Hiragana}|\p{Katakana}/) && b.match?(/\p{Han}/)
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
  max_name_size = file_names.map(&:size_jp).max

  separatiopn_names.transpose_lack.inject('') do |text, names|
    text += "#{names[0..-2].map{ |name| "#{name.ljust_jp(max_name_size)} " }.join}#{names[-1]}\n"
  end
end

input = ARGV[0]
file_names = get_file_names(input)
print generate_name_list_text(file_names, LIST_ROW_NUM)
