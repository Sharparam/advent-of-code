# frozen_string_literal: true

require_relative 'lib/aoc'

Gem::Specification.new 'aoc', AoC::VERSION do |spec|
  spec.authors = ['Adam Hellberg']
  spec.email = ['aoc@sharparam.com']

  spec.summary = 'AoC in Ruby'
  spec.description = 'Advent of Code solutions in Ruby'
  spec.homepage = 'https://github.com/Sharparam/advent-of-code'
  spec.license = 'MPL-2.0'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/Sharparam'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Sharparam/advent-of-code'
  spec.metadata['github_repo'] = 'ssh://github.com/Sharparam/advent-of-code'

  gemspec = File.basename __FILE__
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename f }
  spec.require_paths = ['lib']
end
