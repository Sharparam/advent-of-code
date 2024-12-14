# frozen_string_literal: true

require 'cgi'
require 'net/http'

require_relative 'version'
require_relative 'logging'

module AoC
  # Helper functions to interact with the AoC "API".
  module API
    include Logging

    # User-Agent used for calls to the AoC "API".
    # @return [String]
    USER_AGENT = "Sharparam-AoC/#{AoC::VERSION} (github.com/Sharparam/advent-of-code)".freeze

    # Email address used for the "From" header when calling the AoC "API".
    # @return [String]
    FROM = 'sharparam@sharparam.com'

    # Fetches the input data (string) for a given year and day.
    # @param year [Integer] The year to fetch.
    # @param day [Integer] The day to fetch.
    # @param session_id [String] Session ID for authentication.
    # @param dry_run [Boolean] If dry run is enabled, no HTTP calls will be made and dummy data will be returned.
    # @return [String]
    def self.input(year, day, session_id, dry_run: false)
      url = "https://adventofcode.com/#{year}/day/#{day}/input"
      if dry_run
        log.warn('DRY RUN DOWNLOAD', url:)
        return 'DRY RUN DOWNLOAD CONTENT'
      end
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        log.debug('Downloading input', url:)
        request = Net::HTTP::Get.new(uri)
        request['User-Agent'] = USER_AGENT
        request['From'] = FROM
        request['Cookie'] = "session=#{CGI.escape session_id}"
        response = http.request request
        log.debug 'Got response', status_code: response.code, message: response.message
        raise "Input download request failed (#{response.code} #{response.message})" unless response.code == '200'
        response.body
      end
    end
  end
end
