#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

LIST_ROW_NUM = 3

def divide_equal(file_names, number)
  split_num = (file_names.size / number.to_f).ceil
  file_names.each_slice(split_num).to_a
end

def transpose_lack(uneven_size_array)
  # Array#teansposeとは異なり、二次元配列の要素のサイズが異なっても転置できるメソッド
  max_size = uneven_size_array.map(&:size).max
  uneven_size_array.map { |element| element + [nil] * (max_size - element.size) }.transpose.map(&:compact)
end

def sort_jp(jp_array)
  # Array#sortとは異なり、漢字→ひらがな→カタカナの順にソートするメソッド
  jp_array.sort do |a, b|
    if a.match?(/\p{Han}/) && b.match?(/\p{Hiragana}|\p{Katakana}/)
      -1
    elsif a.match?(/\p{Hiragana}|\p{Katakana}/) && b.match?(/\p{Han}/)
      1
    else
      a <=> b
    end
  end
end

def size_jp(jp_string)
  # String#sizeと異なり、日本語を2文字とみなすメソッド
  jp_string.each_char.sum do |char|
    if char.match?(/\p{Han}|\p{Hiragana}|\p{Katakana}|ー|（|）/)
      2
    else
      1
    end
  end
end

def ljust_jp(jp_string, max_size)
  jp_string + ' ' * (max_size - size_jp(jp_string))
end

def get_file_names(argument_name, options)
  argument_name ||= '.'
  absolute_path = File.expand_path(argument_name)
  target_dir, target_file = path_to_directory_and_file(absolute_path)
  select_files(target_dir, target_file, options)
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

def select_files(target_dir, target_file, options)
  file_names_all = sort_jp(Dir.entries(target_dir).map(&:unicode_normalize))
  # String#unicode_normalizeしないとsortや文字カウントがズレる
  file_names_all.reverse! if options['r']

  if target_file.empty?
      file_names_all.reject! { |file_name| file_name =~ /^\./ } unless options['a']
      # オプション -a 以外の時は '.', '..', '.ファイル名'を除外する
  else
    file_names_all.select! { |file_name| file_name == target_file } # '.ファイル名'も表示対象
  end
  options['l'] ? get_files_info_text(target_dir, file_names_all) : file_names_all
end

def get_files_info_text(target_dir, file_names_all)
  files_info_list = get_files_info_list(target_dir, file_names_all)
  files_size_list = files_info_list.map(&:size).map(&:to_s)
  max_text_size_of_file_size = files_size_list.map(&:size).max
  files_info_text = files_size_list.map{ |size| size.rjust(max_text_size_of_file_size) }
end

def get_files_info_list(target_dir, file_names_all)
  files_info_list = []
  file_names_all.each do |file_name|
    files_info_list += [File::Stat.new("#{target_dir}/#{file_name}")]
  end
  files_info_list
end

def generate_name_list_text(file_names, number, options)
  options['l'] ? row_max_num = 1 : row_max_num = number
  separatiopn_names = divide_equal(file_names, row_max_num)
  max_name_size = file_names.map { |file_name| size_jp(file_name) }.max

  transpose_lack(separatiopn_names).inject('') do |text, names|
    text + "#{names[0..-2].map { |name| "#{ljust_jp(name, max_name_size)} " }.join}#{names[-1]}\n"
  end
end

options = {}
opt = OptionParser.new
opt.on('-a') { options['a'] = true }
opt.on('-r') { options['r'] = true }
opt.parse!(ARGV) # オプション除いて残った引数
input = ARGV[0]

file_names = get_file_names(input, options)
print generate_name_list_text(file_names, LIST_ROW_NUM, options)
