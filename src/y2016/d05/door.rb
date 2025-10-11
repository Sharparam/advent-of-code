# frozen_string_literal: true

require 'digest'

class Door
  def initialize(id)
    @id = id
  end

  def password_simple
    @password_simple ||= generate_simple
  end

  def password_hard
    @password_hard ||= generate_hard
  end

  def self.valid?(str)
    str.start_with? '00000'
  end

  def self.filled?(arr)
    (0..7).all? { |i| !arr[i].nil? }
  end

  private

  def gen
    Digest::MD5.hexdigest "#{@id}#{@counter}"
  end

  def next_hash
    g = gen

    until self.class.valid? g
      @counter += 1
      g = gen
    end

    @counter += 1

    g
  end

  def generate_simple
    @counter = 0
    @hashes = []

    @password_simple = []

    8.times do
      g = next_hash

      @hashes << g
      @password_simple << g[5]

      puts "#{g}:#{@password_simple.join}"
    end

    @password_simple = @password_simple.join
  end

  def generate_hard
    def to_i(char) # rubocop:disable Lint/NestedMethodDefinition
      Integer(char)
    rescue ArgumentError
      nil
    end

    generate_simple unless @password_simple

    @password_hard = []

    # First look at the hashes we already have
    @hashes.each do |h|
      index = to_i h[5]
      next unless index && index >= 0 && index < 8
      next if @password_hard[index]
      @password_hard[index] = h[6]
      puts "#{h}:#{@password_hard.map { |c| c || '_' }.join}"
    end

    until self.class.filled? @password_hard
      g = next_hash

      index = to_i g[5]
      next unless index && index >= 0 && index < 8
      next if @password_hard[index]
      @password_hard[index] = g[6]

      @hashes << g

      puts "#{g}:#{@password_hard.map { |c| c || '_' }.join}"
    end

    @password_hard = @password_hard.join
  end
end
