# encoding: utf-8
# force_string_literal: true

class Address
  ABBA_PATTERN = /([a-z0-9])(?!\1)([a-z0-9])\2\1/

  ABA_PATTERN = /(?=(([a-z0-9])(?!\2)[a-z0-9]\2))/

  def initialize(input)
    @raw = input

    init_supernets!
    init_hypernets!
  end

  def tls?
    @supernets.any? { |p| p =~ ABBA_PATTERN } && @hypernets.all? { |p| p !~ ABBA_PATTERN }
  end

  def ssl?
    @supernets.any? do |snet|
      snet.scan(ABA_PATTERN).any? do |data|
        inverse = [data.first[1], data.first[0], data.first[1]].join
        @hypernets.any? { |hnet| hnet.include? inverse }
      end
    end
  end

  private

  def init_supernets!
    @supernets = @raw.scan(/[^\]][a-z0-9]+[^\[]/).select { |p| p[0] != '[' }
  end

  def init_hypernets!
    @hypernets = @raw.scan(/(?<=[\[])[a-z0-9]+(?=[\]])/)
  end
end
