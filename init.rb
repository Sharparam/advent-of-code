#!/usr/bin/env ruby

require 'cgi'
require 'date'
require 'fileutils'
require 'net/http'
require 'optparse'
require 'pp'
require 'yaml'

options = {}

begin
  OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options]"
    opts.on('-v', '--[no-]verbose', 'Verbose output')
    opts.on('--[no-]dry-run', 'Perform a dry run')
    opts.on('-yYEAR', '--year=YEAR', Integer, 'Year')
    opts.on('-dDAY', '--day=DAY', Integer, 'Day')
    opts.on('-sSESSION', '--session=SESSION', 'Session ID')
    opts.on('-oFILE', '--output=FILE', 'Output filename')
  end.parse! into: options
rescue OptionParser::MissingArgument => e
  abort e.message
end

now = DateTime.now
verbose = options[:verbose]
dry_run = options[:'dry-run']
year = options[:year] || now.year
day = options[:day] || now.day
session_id = options[:session] || YAML.load_file('init.yml')['session']
filename = options[:output] || "#{year}/#{'%02d' % day}/input"
input_url = "https://adventofcode.com/#{year}/day/#{day}/input"

pp options if verbose

abort 'Target file already exists' if File.exist? filename
abort 'Missing session token' unless session_id

puts "Session token is #{session_id}" if verbose

filedir = File.dirname filename
unless filedir == '.' || File.directory?(filedir)
  puts "Creating directory for output file (#{filedir})" if verbose
  FileUtils.mkdir_p filedir
end

uri = URI(input_url)

if dry_run
  puts "DRYRUN DL: #{uri}"
  open(filename, 'w') { |f| f.write 'DRYRUN DOWNLOAD CONTENT' }
else
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    puts "Performing GET request to #{uri}" if verbose
    request = Net::HTTP::Get.new(uri)
    request['Cookie'] = "session=#{CGI.escape session_id}"
    response = http.request request
    puts "Response: #{response.code} #{response.message}" if verbose
    abort "Request failed (#{response.code} #{response.message})" unless response.code == '200'
    puts "Writing response to #{filename}"
    open(filename, 'w') { |f| f.write response.body }
  end
end

puts 'OK' if verbose
