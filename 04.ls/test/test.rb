#!/usr/bin/env ruby
# frozen_string_literal: true

# ruby-practices/04.ls/testで実行を想定
require 'minitest/autorun'
require_relative '../lib/my-ls'

class TestNameReciever < Minitest::Test
  def test_get_file_names_no_argument
    assert_equal ['test.rb', 'test_target'], get_file_names('')
  end

  def test_get_file_names_dir_argument
    assert_equal ['a_test.txt', 'b_test.rb', 'sub.dir', '試験.txt', 'てすと', 'テスト-ターゲット.md'], get_file_names('test_target')
    assert_equal %w[lib test], get_file_names('..')
    # assert_equal ['test.rb', 'test_target'], get_file_names('/Users/atsushi/Documents/Fjord/ruby-practices/04.ls/test') # 絶対パス確認用
    # assert_equal ['test.rb', 'test_target'], get_file_names('~/Documents/Fjord/ruby-practices/04.ls/test/') # 絶対パス確認用(ホームディレクトリから)
  end

  def test_get_file_names_file_argument
    assert_equal ['test.rb'], get_file_names('test.rb')
    assert_equal ['試験.txt'], get_file_names('test_target/試験.txt')
    assert_equal ['テスト-ターゲット.md'], get_file_names('test_target/テスト-ターゲット.md')
    assert_equal ['.test'], get_file_names('test_target/.test')
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

class TestGenerationNameListText < Minitest::Test
  def test_generate_name_list_text_1file
    assert_equal "abc\n", generate_name_list_text(['abc'], 3)
  end

  def test_generate_name_list_text_only_alphabet
    assert_equal "abc bc\n", generate_name_list_text(%w[abc bc], 3)
    assert_equal "abc bc  c\n", generate_name_list_text(%w[abc bc c], 3)
    assert_equal "abc c\nbc  d\n", generate_name_list_text(%w[abc bc c d], 3)
  end

  def test_generate_name_list_text_with_japanese
    assert_equal "人生       苦もあるさ\n", generate_name_list_text(%w[人生 苦もあるさ], 3)
    assert_equal "人生       happy.rb   苦もあるさ\n", generate_name_list_text(['人生', 'happy.rb', '苦もあるさ'], 3)
    assert_equal "人生       苦もあるさ happy.rb\n", generate_name_list_text(['人生', '苦もあるさ', 'happy.rb'], 3)
    result_text = <<~TEXT
      life.md    楽ありゃ   苦もあるさ
      人生       happy.rb
    TEXT
    assert_equal result_text, generate_name_list_text(['life.md', '人生', '楽ありゃ', 'happy.rb', '苦もあるさ'], 3)
  end

  def test_generate_name_list_text_with_files
    result_text = <<~TEXT
      a_test.txt           sub.dir              試験.txt
      b_test.rb            テスト-ターゲット.md
    TEXT
    assert_equal result_text, generate_name_list_text(['a_test.txt', 'b_test.rb', 'sub.dir', 'テスト-ターゲット.md', '試験.txt'], 3)
  end
end