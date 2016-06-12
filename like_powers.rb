#!/usr/bin/env ruby

# Disprove Euler's conjecture on sums of like powers.
# In 1966, finding the smallest example took a computer the size of  a van.
# http://fermatslibrary.com/s/counterexample-to-eulers-conjecture-on-sums-of-like-powers

MAX_ADDER = 150
MAX_BASE = 150
MAX_POWER = 6

def format(set, base, power)
  set.map { |i| "#{i}^#{power}" }.join(' + ') + " = #{base}^#{power}"
end

def increment(set, max, skip: false)
  set.each.with_index do |n, i|
    if n == max || skip
      skip = false
      set[i] = 1
    else
      set[i] += 1
      (i - 1).downto(0).each {|j| set[j] = set[j + 1] }
      break
    end
  end
end

tries = 0
5.upto(MAX_POWER) do |power|
  144.upto(MAX_BASE) do |base|
    set = Array.new(power - 1) { 1 }
    total = base ** power
    until set.all? { |i| i == MAX_ADDER }
      sum = set.map { |i| i ** power }.inject(:+)
      case
      when sum == total
        puts tries, format(set, base, power)
        exit
      when sum > total then increment(set, MAX_ADDER, skip: true)
      else increment(set, MAX_ADDER)
      end
      tries += 1
    end
  end
end
