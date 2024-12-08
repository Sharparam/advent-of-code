#!/usr/bin/env ruby
# frozen_string_literal: true

FOODS = ARGF.readlines.map do |f|
  f =~ /((?:\w+ ?)+)\(contains ((?:\w+(?:, )?)+)\)/
  [$1.split, $2.split(?,)].map { |v| v.map { _1.strip.to_sym } }
end

ALL_INGREDIENTS = FOODS.flat_map(&:first)
INGREDIENTS = ALL_INGREDIENTS.to_set
ALLERGENS = FOODS.flat_map { _2 }.to_set

ALLERGEN_INGREDIENTS = Hash[ALLERGENS.map do |a|
  [a, FOODS.select { _2.include? a }.map(&:first).reduce(:intersection)]
end]

puts (ALL_INGREDIENTS - ALLERGEN_INGREDIENTS.values.flatten).size

while ALLERGEN_INGREDIENTS.values.any? { _1.count > 1 }
  singles = ALLERGEN_INGREDIENTS.values.select { _1.count == 1 }.flatten.to_set
  ALLERGEN_INGREDIENTS.values.select { _1.count > 1 }.each do |v|
    v.reject! { singles.include? _1 }
  end
end

puts ALLERGEN_INGREDIENTS.sort_by(&:first).map { _2.first }.join ?,
