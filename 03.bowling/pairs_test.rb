#!/usr/bin/env ruby
# frozen_string_literal: true


def paris_in_range?(pairs)
  puts !pairs.empty? && (pairs.last&.size || 0) < 2 && (pairs.last&.last || 0) < 10
end

pairs = []
paris_in_range?(pairs) #=> false
pairs = [[]]
paris_in_range?(pairs) #=> true
pairs = [[2]]
paris_in_range?(pairs) #=> true

def paris_in_range2?(pairs)
  puts (pairs.last&.size || 10) < 2 && (pairs.last&.last || 0) < 10
end

pairs = []
paris_in_range2?(pairs) #=> false
pairs = [[]]
paris_in_range2?(pairs) #=> true
pairs = [[2]]
paris_in_range2?(pairs) #=> true

