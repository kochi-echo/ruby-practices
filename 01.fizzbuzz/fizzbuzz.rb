#!/usr/bin/env ruby
# frozen_string_literal: true

def fizz(num)
  'Fizz' if (num % 3).zero?
end

def buzz(num)
  'Buzz' if (num % 5).zero?
end

def fizzbuzz(max_count)
  (1..max_count).each do |n|
    fizzbuzz_string = "#{fizz(n)}#{buzz(n)}"
    puts fizzbuzz_string.empty? ? n : fizzbuzz_string
  end
end

fizzbuzz(20)
