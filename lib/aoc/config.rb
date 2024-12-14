# frozen_string_literal: true

require 'tomlib'

module AoC
  # Config utilities.
  class Config
    # Session token for accessing AoC website.
    # @return [String]
    attr_reader :session

    # Creates a new config instance.
    # @param options [Hash] Hash containing the options to use.
    def initialize(**options)
      @session = options.dig('api', 'session')
    end

    # Loads a new config instance from file.
    # @param path [String]
    # @return [Config]
    def self.load(path)
      data = File.read path
      options = Tomlib.load data
      new(**options)
    end
  end
end
