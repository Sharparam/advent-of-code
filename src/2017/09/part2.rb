#!/usr/bin/env ruby
# frozen_string_literal: true

p $<.read.strip.gsub(/!./, '').scan(/<([^>]*)>/).reduce(0) { |a, e| a + e.first.size }
