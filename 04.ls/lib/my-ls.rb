#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

LIST_ROW_NUM = 3

def argument_to_files_info_list(argument_text, options)
  argument_text ||= '.'
  absolute_path = File.expand_path(argument_text)
  target_directory, target_file = path_to_directory_and_file(absolute_path)

  all_files_name = sort_jp(Dir.entries(target_directory).map(&:unicode_normalize))
  # String#unicode_normalizeしないとsortや文字カウントがズレる
  all_files_name.reverse! if options['r']

  if target_file.empty?
    all_files_name.reject! { |file_name| file_name.match?(/^\./) && !options['a'] }
    # オプション -a 以外の時は '.', '..', '.ファイル名'を除外する
  else
    all_files_name = [target_file]
  end

  options['l'] ? files_total_blocks_and_detail_info_list(target_directory, all_files_name) : all_files_name
end

def path_to_directory_and_file(absolute_path)
  if File.file?(absolute_path)
    target_directory = File.dirname(absolute_path)
    target_file = File.basename(absolute_path)
  else
    target_directory = absolute_path
    target_file = ''
  end
  [target_directory, target_file]
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

def files_total_blocks_and_detail_info_list(target_directory, all_files_name)
  total_blocks = if all_files_name.size > 1
                   ["total #{directory_and_files_to_files_status(target_directory, all_files_name).map(&:blocks).sum}"]
                 else
                   []
                 end
  total_blocks + files_detail_info_list(target_directory, all_files_name).values.transpose.map(&:join)
end

def files_detail_info_list(target_directory, all_files_name)
  files_status = directory_and_files_to_files_status(target_directory, all_files_name)
  {
    mode: files_mode_to_l_option_format(files_status.map(&:mode), 1),
    number_of_link: align_str_list_to_right(files_status.map { |file_info| file_info.nlink.to_s }, 1),
    user_name: align_jp_str_list_to_left(files_status.map { |file_info| Etc.getpwuid(file_info.uid).name.to_s }, 2),
    group_name: align_jp_str_list_to_left(files_status.map { |file_info| Etc.getgrgid(file_info.gid).name.to_s }, 2),
    size: align_str_list_to_right(files_status.map { |file_info| file_info.size.to_s }, 2),
    mtime: files_mtime_to_l_option_format(files_status.map(&:mtime), 1),
    file_name: align_jp_str_list_to_left(all_files_name, 0)
  }
end

def directory_and_files_to_files_status(target_directory, all_files_name)
  all_files_name.map { |file_name| File::Stat.new("#{target_directory}/#{file_name}") }
end

def files_mode_to_l_option_format(files_mode, number_of_space)
  files_mode_chars = files_mode.map do |file_mode|
    file_mode_bits = format('%016b', file_mode)
    {
      file_type: file_type_bit_to_char(file_mode_bits[0..3]),
      owner_permission: permission_bits_to_str(file_mode_bits[7..9], file_mode_bits[4], 'Ss'),
      group_permission: permission_bits_to_str(file_mode_bits[10..12], file_mode_bits[5], 'Ss'),
      others_permission: permission_bits_to_str(file_mode_bits[13..15], file_mode_bits[6], 'Tt')
    }
  end
  files_mode_chars.map do |chars|
    "#{chars[:file_type]}#{chars[:owner_permission]}#{chars[:group_permission]}#{chars[:others_permission]}@#{' ' * number_of_space}"
  end
end

def file_type_bit_to_char(file_type_bit)
  file_type_char = { # file_modeに対する、8進数対応表 cf. Linux file type and mode Doc
    '0o01'.to_i(8) => 'p', # FIFO
    '0o02'.to_i(8) => 'c', # Character special file
    '0o04'.to_i(8) => 'd', # Directory(ディレクトリ)
    '0o06'.to_i(8) => 'b', # Block special file
    '0o10'.to_i(8) => '-', # Regular file(通常ファイル)
    '0o12'.to_i(8) => 'l', # Symbolic link(シンボリックリンク)
    '0o14'.to_i(8) => 's'  # Socket link
  }
  file_type_char[file_type_bit.to_i(2)]
end

def permission_bits_to_str(permission_bits, special_permission_bit, mark)
  file_permission = ['-', '-', '-']
  file_permission[0] = 'r' if permission_bits[0] == '1'
  file_permission[1] = 'w' if permission_bits[1] == '1'
  file_permission[2] = ['-x', mark][special_permission_bit.to_i][permission_bits[2].to_i] # 2次元テーブルから実行権限記号を選択
  file_permission.join
end

def files_mtime_to_l_option_format(files_mtime, number_of_space)
  files_each_mtime = {}
  files_each_mtime['month'] = align_str_list_to_right(files_mtime.map(&:month).map(&:to_s), 1)
  files_each_mtime['day'] = align_str_list_to_right(files_mtime.map(&:day).map(&:to_s), 1)
  files_each_mtime['time'] = align_str_list_to_right(files_mtime.map { |mtime| mtime.strftime('%R') }, number_of_space)
  [files_each_mtime['month'], files_each_mtime['day'], files_each_mtime['time']].transpose.map(&:join)
end

def align_str_list_to_right(str_list, number_of_space)
  max_size_str = str_list.map(&:size).max
  str_list.map { |str| str.rjust(max_size_str) + ' ' * number_of_space }
end

def align_jp_str_list_to_left(str_list, number_of_space)
  max_size_str = str_list.map { |str| size_jp(str) }.max
  str_list.map { |str| ljust_jp(str, max_size_str) + ' ' * number_of_space }
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

def files_info_list_to_displayed_text(file_names, number, options)
  row_max_number = options['l'] ? 1 : number
  separatiopn_names = divide_equal(file_names, row_max_number)
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

files_info_list = argument_to_files_info_list(input, options)
print files_info_list_to_displayed_text(files_info_list, LIST_ROW_NUM, options)
