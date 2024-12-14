# frozen_string_literal: true

require 'ougai'

module AoC
  # Logger object used in AoC code, currently just an Ougai logger.
  class Logger < Ougai::Logger
    # Initializes the logger.
    def initialize(*, **)
      super
    end
  end
end
