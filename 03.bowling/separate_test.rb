#!/usr/bin/env ruby
# frozen_string_literal: true

def separate_frame(all_pins)
  all_pins.each_with_object([[]]) do |pin, pairs|
    if !pairs.empty? && (pairs.last&.size || 0) < 2 && (pairs.last&.last || 0) < 10
    pairs.last << pin
    else
      pairs << [pin]
    end
  end
end

pp separate_frame([]) #=> [[]]
pp separate_frame([1]) #=> [[1]]
pp separate_frame([1,2,3,4]) #=> [[1, 2], [3, 4]]
pp separate_frame([1,2,10,4,5]) #=> [[1, 2], [10], [4, 5]]
