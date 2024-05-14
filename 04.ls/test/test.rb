#!/usr/bin/env ruby
# frozen_string_literal: true

# ruby-practices/04.ls/testで実行を想定
require 'minitest/autorun'
require_relative '../lib/my-ls'

class TestNameReciever < Minitest::Test
  def test_get_file_names_no_argument
    assert_equal ['test.rb', 'test_target'], get_file_names('', { 'a' => false })
    assert_equal ['.', '..', '.ruby-lsp', 'test.rb', 'test_target'], get_file_names('', { 'a' => true })
    assert_equal ['test_target', 'test.rb'], get_file_names('', { 'r' => true })
    assert_equal ['test_target', 'test.rb', '.ruby-lsp', '..', '.'], get_file_names('', { 'a' => true, 'r' => true })
  end

  def test_get_file_names_dir_argument
    assert_equal ['a_test.txt', 'b_test.rb', 'sub.dir', '試験.txt', 'てすと', 'テスト-ターゲット.md'],
                 get_file_names('test_target', { 'a' => false })
    assert_equal %w[lib test], get_file_names('..', { 'a' => false })
    # assert_equal ['test.rb', 'test_target'], get_file_names('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test', {"a"=>false }) # 絶対パス確認用
    # assert_equal ['test.rb', 'test_target'], get_file_names('~/Documents/Fjord/ruby-practices/04.ls/test/', {"a"=>false }) # 絶対パス確認用(ホームディレクトリから)
    assert_equal ['.', '..', '.dot_subdir', '.test', 'a_test.txt', 'b_test.rb', 'sub.dir', '試験.txt', 'てすと', 'テスト-ターゲット.md'],
                 get_file_names('test_target', { 'a' => true })
    assert_equal ['テスト-ターゲット.md', 'てすと', '試験.txt', 'sub.dir', 'b_test.rb', 'a_test.txt'],
                 get_file_names('test_target', { 'r' => true })
    assert_equal ['テスト-ターゲット.md', 'てすと', '試験.txt', 'sub.dir', 'b_test.rb', 'a_test.txt', '.test', '.dot_subdir', '..', '.'],
                 get_file_names('test_target', { 'a' => true, 'r' => true })
    result_list = [
      'total 8',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 a_test.txt          ',
      '-rw-r--r--@ 1 atsushi  staff   38  4 17 11:23 b_test.rb           ',
      'drwxr-xr-x@ 4 atsushi  staff  128  5 14 11:11 sub.dir             ',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 試験.txt            ',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 てすと              ',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 テスト-ターゲット.md'
    ]
    assert_equal result_list, get_file_names('test_target', { 'l' => true })
    # result_list = [
    #   'total 8',
    #   'drwxr-xr-x@ 10 atsushi  staff  320  4 17 11:23 .                   ',
    #   'drwxr-xr-x@  5 atsushi  staff  160  5 13 07:57 ..                  ',
    #   'drwxr-xr-x@  2 atsushi  staff   64  4 17 10:14 .dot_subdir         ',
    #   '-rw-r--r--@  1 atsushi  staff    0  4 17 11:23 .test               ',
    #   '-rw-r--r--@  1 atsushi  staff    0  4 17 11:23 a_test.txt          ',
    #   '-rw-r--r--@  1 atsushi  staff   38  4 17 11:23 b_test.rb           ',
    #   'drwxr-xr-x@  3 atsushi  staff   96  4 17 11:23 sub.dir             ',
    #   '-rw-r--r--@  1 atsushi  staff    0  4 17 11:23 試験.txt            ',
    #   '-rw-r--r--@  1 atsushi  staff    0  4 17 11:23 てすと              ',
    #   '-rw-r--r--@  1 atsushi  staff    0  4 17 11:23 テスト-ターゲット.md'
    # ]
    # assert_equal result_list, get_file_names('test_target', { 'l' => true, 'a' => 'true' })
    # '..'のmtimeが勝手に変わるためテスト不可
    result_list = [
      'total 0',
      '-rwSr--r--@ 1 atsushi  staff  0  4 17 11:23 test_permission_large_s.txt',
      '-rwsr--r--@ 1 atsushi  staff  0  4 17 11:23 test_permission_s.txt      '
    ]
    assert_equal result_list, get_file_names('test_target/sub.dir', { 'l' => true })
    result_list = [
      'total 8',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 テスト-ターゲット.md',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 てすと              ',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 試験.txt            ',
      'drwxr-xr-x@ 4 atsushi  staff  128  5 14 11:11 sub.dir             ',
      '-rw-r--r--@ 1 atsushi  staff   38  4 17 11:23 b_test.rb           ',
      '-rw-r--r--@ 1 atsushi  staff    0  4 17 11:23 a_test.txt          '
    ]
    assert_equal result_list, get_file_names('test_target', { 'l' => true, 'r' => true })
  end

  def test_get_file_names_file_argument
    assert_equal ['test.rb'], get_file_names('test.rb', { 'a' => false })
    assert_equal ['試験.txt'], get_file_names('test_target/試験.txt', { 'a' => false })
    assert_equal ['テスト-ターゲット.md'], get_file_names('test_target/テスト-ターゲット.md', { 'a' => false })
    assert_equal ['.test'], get_file_names('test_target/.test', { 'a' => false })
  end
end

class TestArrayMethod < Minitest::Test
  def test_divide_equal
    assert_equal [[1, 2], [3, 4], [5]], divide_equal([1, 2, 3, 4, 5], 3)
    assert_equal [[1, 2], [3, 4], [5, 6]], divide_equal([1, 2, 3, 4, 5, 6], 3)
  end

  def transpose_lack
    assert_equal [[1, 3, 5], [2, 4]], transpose_lack([[1, 2], [3, 4], [5]])
    assert_equal [[1, 4, 7], [2, 5], [3, 6]], transpose_lack([[1, 2, 3], [4, 5, 6], [7]])
  end

  def test_sort_jp
    assert_equal [
      'a_test.txt', 'b_test.rb', 'sub.dir', '試験.txt', 'てすと', 'テスト-ターゲット.md'
    ], sort_jp([
                 'b_test.rb', 'a_test.txt', 'テスト-ターゲット.md', '試験.txt', 'sub.dir', 'てすと'
               ])
  end
end

class TestStringMethod < Minitest::Test
  def test_size_jp
    assert_equal 3, size_jp('abc')
    assert_equal 6, size_jp('あいう')
    assert_equal 4, size_jp('aあc')
  end

  def test_ljust_jp
    assert_equal 'abc   ', ljust_jp('abc', 6)
    assert_equal 'あいう', ljust_jp('あいう', 6)
    assert_equal 'あいう  ', ljust_jp('あいう', 8)
  end
end

class TestGetFilesInfoText < Minitest::Test
  def test_get_mode
    assert_equal ['-rw-r--r--@ '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['mode']
    assert_equal ['-rw-r--r--@ ', 'drwxr-xr-x@ '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'sub.dir'])['mode']
  end

  def test_get_number_of_link
    assert_equal ['1 '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['number_of_link']
    assert_equal ['1 ', '4 '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'sub.dir'])['number_of_link']
  end

  def test_get_user_name
    assert_equal ['atsushi  '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['user_name']
    assert_equal ['atsushi  ', 'atsushi  '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'sub.dir'])['user_name']
  end

  def test_get_group_name
    assert_equal ['staff  '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['group_name']
    assert_equal ['staff  ', 'staff  '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'sub.dir'])['group_name']
  end

  def test_get_size
    assert_equal ['38  '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['size']
    assert_equal [' 0  ', '38  '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'b_test.rb'])['size']
  end

  def test_get_mtime
    assert_equal ['4 17 11:23 '], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['mtime']
    assert_equal ['4 17 11:23 ', '4 17 11:23 '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'b_test.rb'])['mtime']
  end

  def test_get_file_name
    assert_equal ['b_test.rb'], get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])['file_name']
    assert_equal ['a_test.txt', 'sub.dir   '],
                 get_files_info_each_type('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['a_test.txt', 'sub.dir'])['file_name']
  end
end

class TestGetFilesInfoText < Minitest::Test
  def test_get_files_info_text
    assert_equal ['-rw-r--r--@ 1 atsushi  staff  38  4 17 11:23 b_test.rb'],
                 get_files_info_text('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb'])
    assert_equal ['total 8', '-rw-r--r--@ 1 atsushi  staff   38  4 17 11:23 b_test.rb', 'drwxr-xr-x@ 4 atsushi  staff  128  5 14 11:11 sub.dir  '],
                 get_files_info_text('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test/test_target', ['b_test.rb', 'sub.dir'])
  end
end

class TestAlignStrMethod < Minitest::Test
  def test_align_str_list_to_right
    assert_equal [' 1', '10'], align_str_list_to_right(%w[1 10], 0)
  end

  def align_jp_str_list_to_left
    assert_equal ['あ  ', 'うえ'], align_str_list_to_right(%w[あ うえ], 0)
  end
end

class TestGenerationNameListText < Minitest::Test
  def test_generate_name_list_text_1file
    assert_equal "abc\n", generate_name_list_text(['abc'], 3, { 'l' => false })
  end

  def test_generate_name_list_text_only_alphabet
    assert_equal "abc bc\n", generate_name_list_text(%w[abc bc], 3, { 'l' => false })
    assert_equal "abc bc  c\n", generate_name_list_text(%w[abc bc c], 3, { 'l' => false })
    assert_equal "abc c\nbc  d\n", generate_name_list_text(%w[abc bc c d], 3, { 'l' => false })
  end

  def test_generate_name_list_text_with_japanese
    assert_equal "人生       苦もあるさ\n", generate_name_list_text(%w[人生 苦もあるさ], 3, { 'l' => false })
    assert_equal "人生\n苦もあるさ\n", generate_name_list_text(%w[人生 苦もあるさ], 3, { 'l' => true })
    assert_equal "人生       happy.rb   苦もあるさ\n", generate_name_list_text(['人生', 'happy.rb', '苦もあるさ'], 3, { 'l' => false })
    assert_equal "人生       苦もあるさ happy.rb\n", generate_name_list_text(['人生', '苦もあるさ', 'happy.rb'], 3, { 'l' => false })
    result_text = <<~TEXT
      life.md    楽ありゃ   苦もあるさ
      人生       happy.rb
    TEXT
    assert_equal result_text, generate_name_list_text(['life.md', '人生', '楽ありゃ', 'happy.rb', '苦もあるさ'], 3, { 'l' => false })
  end

  def test_generate_name_list_text_with_files
    result_text = <<~TEXT
      a_test.txt           sub.dir              試験.txt
      b_test.rb            テスト-ターゲット.md
    TEXT
    assert_equal result_text, generate_name_list_text(['a_test.txt', 'b_test.rb', 'sub.dir', 'テスト-ターゲット.md', '試験.txt'], 3, { 'l' => false })
  end
end
