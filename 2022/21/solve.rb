#!/usr/bin/env ruby
# frozen_string_literal: true

eval ARGF.read.gsub(/(\w+): (.+)\n?/, 'def \1(); \2; end;')

puts root()
