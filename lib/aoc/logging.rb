# frozen_string_literal: true

module AoC
  # Include-able module to enable logging from modules and classes.
  module Logging
    # Get the {AoC::Logger} instance for the current object.
    # @return [AoC::Logger]
    def log
      self.class.log
    end

    @out = $stderr
    @level = Logger::INFO
    @formatter = Ougai::Formatters::Readable.new
    @loggers = {}

    class << self
      # @param value [IO]
      attr_writer :out

      attr_writer :formatter

      def level=(level)
        @level = level
        @loggers.each_value { |l| l.level = level }
      end

      def logger_for(source)
        name = source_to_name source
        @loggers[name] ||= Logger.new(@out, progname: name, level: @level).tap do |l|
          l.formatter = @formatter
        end
      end

      def source_to_name(source)
        if source.respond_to? :name
          source.name
        elsif source.is_a? String
          source
        else
          source.to_s
        end
      end

      def included(base)
        class << base
          def log
            @log ||= Logging.logger_for self
          end
        end
      end
    end
  end
end
