#!/usr/bin/env ruby
# frozen_string_literal: true

PATTERNS = ARGF.readline.split(', ').map(&:strip)
DESIGNS = ARGF.read.strip.lines.map(&:strip)

# REGEX = %r{^(?:#{PATTERNS.join('|')})+$}

$counts = {}

def solve(design)
  return 1 if design == ''
  $counts[design] ||= PATTERNS.select { design.start_with? _1 }.sum { solve design[_1.size..] }
end

# puts DESIGNS.count { _1 =~ REGEX }
puts DESIGNS.count { solve(_1) > 0 }
puts DESIGNS.sum { solve _1 }
