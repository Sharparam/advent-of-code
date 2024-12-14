# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rake/clean'

require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new :spec

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

YARD::Rake::YardocTask.new

desc 'Generate RBS file'
task :rbs do
  sh 'sord sig/aoc.rbs'
end

namespace :aoc do
  desc 'Generate documentation and RBS file'
  task doc: %i[yard rbs]
end

CLOBBER << 'sig/aoc.rbs'
CLOBBER << 'doc/yard'
