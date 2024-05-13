#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'jp_methods.rb'

def convert_files_mode_to_l_option_format(files_mode, number_of_space)
  files_mode_chars = files_mode.map do |file_mode|
    file_mode_bits = format('%016b', file_mode)
    {
      'file_type' => convert_file_type_bit_to_char(file_mode_bits[0..3]),
      'owner_permission' => convert_permission_bits_to_str(file_mode_bits[7..9], file_mode_bits[4]),
      'group_permission' => convert_permission_bits_to_str(file_mode_bits[10..12], file_mode_bits[5]),
      'others_permission' => convert_permission_bits_to_str(file_mode_bits[13..15], file_mode_bits[6])
    }
  end
  files_mode_chars.map do |chars|
    chars['file_type'] + chars['owner_permission'] + chars['group_permission'] + chars['others_permission'] + '@' + ' '*number_of_space
  end
end

def convert_file_type_bit_to_char(file_type_bit)
  file_type_char = { # file_modeに対する、8進数対応表 cf. Linux file type and mode Doc
    '0o01'.to_i(8) =>	'p', # FIFO
    '0o02'.to_i(8) => 'c', # Character special file
    '0o04'.to_i(8) =>	'd', # Directory(ディレクトリ)
    '0o06'.to_i(8) =>	'b', # Block special file
    '0o10'.to_i(8) =>	'-', # Regular file(通常ファイル)
    '0o12'.to_i(8) =>	'l', # Symbolic link(シンボリックリンク)
    '0o14'.to_i(8) =>	's'	 # Socket link
  }
  file_type_char[file_type_bit.to_i(2)]
end

def convert_permission_bits_to_str(permission_bits, special_permission_bit)
  file_permission = ['-', '-', '-']
  file_permission[0] = 'r' if permission_bits[0] == '1'
  file_permission[1] = 'w' if permission_bits[1] == '1'
  file_permission[2] = ['-x', 'Ss'][special_permission_bit.to_i][permission_bits[2].to_i] # 2次元テーブルから実行権限記号を選択
  file_permission.join
end

def convert_files_mtime_to_l_option_format(files_mtime, number_of_space)
  files_each_mtime = {}
  files_each_mtime['month'] = align_str_list_to_right(files_mtime.map(&:month).map(&:to_s), 1)
  files_each_mtime['day'] = align_str_list_to_right(files_mtime.map(&:day).map(&:to_s), 1)
  files_each_mtime['time'] = align_str_list_to_right(files_mtime.map { |mtime| "#{mtime.hour}:#{mtime.min}" }, number_of_space)
  [files_each_mtime['month'], files_each_mtime['day'], files_each_mtime['time']].transpose.map(&:join)
end

def align_str_list_to_right(str_list, number_of_space)
  max_size_str = str_list.map(&:size).max
  str_list.map { |str| str.rjust(max_size_str) + ' '*number_of_space }
end

def align_jp_str_list_to_left(str_list, number_of_space)
  max_size_str = str_list.map { |str| size_jp(str) }.max
  str_list.map { |str| ljust_jp(str, max_size_str) + ' '*number_of_space }
end
