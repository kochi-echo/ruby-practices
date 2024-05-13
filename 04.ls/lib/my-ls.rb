#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'jp_methods.rb'
require_relative 'conversion_file_info_methods.rb'

LIST_ROW_NUM = 3

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
  options['l'] ? get_files_info_text_merged(target_dir, file_names_all) : file_names_all
end

def get_files_info_text_merged(target_dir, file_names_all)
  files_info_each_type = get_files_info_each_type(target_dir, file_names_all)
  files_info_text = files_info_each_type['file_name'].map.with_index do |_name, idx|
    "#{files_info_each_type['mode'][idx]} "\
    "#{files_info_each_type['number_of_link'][idx]} "\
    "#{files_info_each_type['user_name'][idx]}  "\
    "#{files_info_each_type['group_name'][idx]}  "\
    "#{files_info_each_type['size'][idx]}  "\
    "#{files_info_each_type['mtime'][idx]} "\
    "#{files_info_each_type['file_name'][idx]}"
  end
  ["total #{file_names_all.map { |file_name| File::Stat.new("#{target_dir}/#{file_name}") }.map(&:blocks).sum}"] + files_info_text
end

def get_files_info_each_type(target_dir, file_names_all)
  files_info = file_names_all.map { |file_name| File::Stat.new("#{target_dir}/#{file_name}") }
  files_info_each_type = {}
  files_info_each_type['mode'] = convert_files_mode_to_l_option_format(files_info.map(&:mode), 1)
  files_info_each_type['number_of_link'] = align_str_list_to_right(files_info.map(&:nlink).map(&:to_s), 1)
  files_info_each_type['user_name'] = align_jp_str_list_to_left(files_info.map { |file_info| Etc.getpwuid(file_info.uid).name.to_s }, 2)
  files_info_each_type['group_name'] = align_jp_str_list_to_left(files_info.map { |file_info| Etc.getgrgid(file_info.gid).name.to_s }, 2)
  files_info_each_type['size'] = align_str_list_to_right(files_info.map(&:size).map(&:to_s), 2)
  files_info_each_type['mtime'] = convert_files_mtime_to_l_option_format(files_info.map(&:mtime), 1)
  files_info_each_type['file_name'] = align_jp_str_list_to_left(file_names_all, 0)
  files_info_each_type
end

def generate_name_list_text(file_names, number, options)
  row_max_num = options['l'] ? 1 : number
  separatiopn_names = divide_equal(file_names, row_max_num)
  max_name_size = file_names.map { |file_name| size_jp(file_name) }.max

  transpose_lack(separatiopn_names).inject('') do |text, names|
    text + "#{names[0..-2].map { |name| "#{ljust_jp(name, max_name_size)} " }.join}#{names[-1]}\n"
  end
end

def divide_equal(file_names, number)
  split_num = (file_names.size / number.to_f).ceil
  file_names.each_slice(split_num).to_a
end

def transpose_lack(uneven_size_array)
  # Array#teansposeとは異なり、二次元配列の要素のサイズが異なっても転置できるメソッド
  max_size = uneven_size_array.map(&:size).max
  uneven_size_array.map { |element| element + [nil] * (max_size - element.size) }.transpose.map(&:compact)
end

options = {}
opt = OptionParser.new
opt.on('-a') { options['a'] = true }
opt.on('-r') { options['r'] = true }
opt.on('-l') { options['l'] = true }
opt.parse!(ARGV) # オプション除いて残った引数
input = ARGV[0]

file_names = get_file_names(input, options)
print generate_name_list_text(file_names, LIST_ROW_NUM, options)
