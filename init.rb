#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'cgi'
require 'date'
require 'fileutils'
require 'net/http'
require 'optparse'

require 'aoc'

options = {}

begin
  OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options]"
    opts.on('-v', '--[no-]verbose', 'Verbose output')
    opts.on('--[no-]dry-run', 'Perform a dry run')
    opts.on('-yYEAR', '--year=YEAR', Integer, 'Year')
    opts.on('-dDAY', '--day=DAY', Integer, 'Day')
    opts.on('-sSESSION', '--session=SESSION', 'Session ID')
  end.parse! into: options
rescue OptionParser::MissingArgument => e
  abort e.message
end

now = DateTime.now
verbose = options[:verbose]
dry_run = options[:'dry-run']
year = options[:year] || now.year
day = options[:day] || now.day
session_id = options[:session] || AoC::Config.load('.config/aoc.toml').session
filename = "data/aoc/#{year}/#{'%02d' % day}/input"
linkname = "src/#{year}/#{'%02d' % day}/input"

AoC::Logging.level = verbose ? AoC::Logger::TRACE : AoC::Logger::INFO

log = AoC::Logging.logger_for 'main'

log.trace(options:)

abort 'Target file already exists' if File.exist? filename
abort 'Missing session token' unless session_id

log.trace(session_id:)

filedir = File.dirname filename
unless filedir == '.' || File.directory?(filedir)
  log.debug "Creating directory for output file (#{filedir})"
  FileUtils.mkdir_p filedir
end

linkdir = File.dirname linkname
unless File.directory?(linkdir)
  log.debug "Creating directory for link file (#{linkdir})"
  FileUtils.mkdir_p linkdir
end

input_content = AoC::API.input(year, day, session_id, dry_run: dry_run)
log.info('Writing response', filename:)
open(filename, 'w') { |f| f.write input_content } # rubocop:disable Security/Open
FileUtils.ln_sr filename, linkname
log.info('Created link for input file', src: filename, dst: linkname)

puts 'OK' if verbose
