#!/usr/bin/env ruby

p $<.read.strip.gsub(/!./, '').scan(/<([^>]*)>/).reduce(0) { |a, e| a + e.first.size }
