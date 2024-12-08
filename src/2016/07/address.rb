# encoding: utf-8
# frozen_string_literal: true

class Address
  ABBA_PATTERN = /([a-z0-9])(?!\1)([a-z0-9])\2\1/

  def initialize(input)
    @raw = input

    @supernets = @raw.scan(/[^\]][a-z0-9]+[^\[]/).reject { |p| p[0] == '[' }
    @hypernets = @raw.scan(/(?<=[\[])[a-z0-9]+(?=[\]])/)
  end

  def tls?
    @supernets.any? { |p| p =~ ABBA_PATTERN } && @hypernets.all? { |p| p !~ ABBA_PATTERN }
  end

  def ssl?
    @supernets.any? do |snet|
      snet.scan(/(?=(([a-z0-9])(?!\2)[a-z0-9]\2))/).any? do |data|
        inverse = [data.first[1], data.first[0], data.first[1]].join
        @hypernets.any? { |hnet| hnet.include? inverse }
      end
    end
  end
end
