# frozen_string_literal: true

module AoC
  # Contains version information.
  module Version
    MAJOR = 1
    MINOR = 0
    PATCH = 0
    FULL = "#{MAJOR}.#{MINOR}.#{PATCH}".freeze

    def self.to_s
      FULL
    end
  end
end
