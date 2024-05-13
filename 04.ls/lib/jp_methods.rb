#!/usr/bin/env ruby
# frozen_string_literal: true

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
