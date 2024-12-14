# frozen_string_literal: true

module AoC
  # Contains version information.
  module Version
    # The major version of the gem.
    # @return [Integer]
    MAJOR = 1

    # The minor version of the gem.
    # @return [Integer]
    MINOR = 0

    # The patch version of the gem.
    # @return [Integer]
    PATCH = 0

    # The full version string.
    # @return [String]
    FULL = "#{MAJOR}.#{MINOR}.#{PATCH}".freeze

    # @return [String] A string representation of the version.
    def self.to_s
      FULL
    end
  end

  # (see Version::FULL)
  VERSION = Version::FULL
end
