# frozen_string_literal: true

require 'tomlib'

module AoC
  class Config
    attr_reader :session

    def initialize(**options)
      @session = options.dig('api', 'session')
    end

    def self.load(path)
      data = File.read path
      options = Tomlib.load data
      new(**options)
    end
  end
end
