# frozen_string_literal: true

class Room
  PATTERN = /^([a-z-]+)-(\d+)\[([a-z]+)\]$/

  ALPHABET_SIZE = 26

  ALPHABET_START = 'a'.ord

  ALPHABET_END = 'z'.ord

  attr_reader :name, :id, :checksum

  def initialize(data)
    match = data.match PATTERN
    @name = match[1]
    @id = match[2].to_i
    @checksum = match[3]
  end

  def real?
    counts = @name.scan(/[a-z]/).each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }

    groups = counts.values.sort.reverse.uniq.map do |count|
      counts.keys.select { |k| counts[k] == count }
    end

    compare = groups.first
    compare_index = 0

    @checksum.chars.each.with_index do |c, _i|
      compare.concat(groups[compare_index += 1]) if compare.empty?
      return false unless compare.include? c
      compare.delete c
    end

    true
  end

  def decrypt
    shift = @id % ALPHABET_SIZE
    @name.chars.map do |c|
      next ' ' if c == '-'
      ascii = c.ord + shift
      ascii = ALPHABET_START + ascii - ALPHABET_END - 1 if ascii > ALPHABET_END
      ascii.chr
    end.join
  end
end
