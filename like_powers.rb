#!/usr/bin/env ruby

require 'pqueue'

# Disprove Euler's conjecture on sums of like powers.
# In 1966, finding the smallest example took a computer the size of  a van.
# http://fermatslibrary.com/s/counterexample-to-eulers-conjecture-on-sums-of-like-powers

def format(set, base, power)
   "(#{base ** power}) #{base}^#{power} = " + set.map { |i| "#{i}^#{power}" }.join(' + ')
end

def add_targets(queue, target)
  base_change  = target.merge(base: target[:base] + 1)
  power_change = target.merge(power: target[:power] + 1)
  queue << base_change  unless queue.include?(base_change)
  queue << power_change unless queue.include?(power_change)
end

def search(base, power)
  tries = 0
  target = base ** power
  puts "Searching for #{base}^#{power}\t(#{target})"

  set = Array.new(power - 1) { 1 }

  loop do
    tries += 1
    #puts "\t#{tries}\t#{format(set, base, power)}"

    addends = set.map { |i| i ** power }
    sum = addends.inject(:+)
    return { tries: tries, set: set } if sum == target # Found one!

    # Increment the working set with rollover as each element reaches the target
    i = 0
    while i < set.size
      set[i] += 1
      break if set[i] < base
      i += 1
    end
    # Every element is base ^ power
    return { tries: tries, set: nil } if i == set.size

    # IF we just did [1, 1] then [2, 1], we don't need to try [1, 2].
    # Skip straight to [2, 2].
    while i > 0
      set[i - 1] = set[i]
      i -= 1
    end
  end
end


target_queue = PQueue.new { |a, b| b[:base] ** b[:power] <=> a[:base] ** a[:power] }
target_queue << { base: 2, power: 3 }

tries = 0
potential_targets = 0
loop do
  target = target_queue.pop
  potential_targets += 1

  result = search(target[:base], target[:power])

  tries += result[:tries]
  if result[:set]
    puts "Done! #{tries} tries. #{potential_targets} targets. #{format(result[:set], target[:base], target[:power])}"
    exit
  end

  add_targets(target_queue, target)
end
