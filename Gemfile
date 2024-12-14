# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'amazing_print', '~> 1.6'
gem 'ougai', '~> 2.0'
gem 'tomlib', '~> 0.7.3'

group :development do
  gem 'profile', '~> 0.4.0'
  gem 'pry', '~> 0.15.0'
  gem 'rubocop', '~> 1.69', '>= 1.69.2'
  gem 'rubocop-rake', '~> 0.6.0'
  gem 'rubocop-rspec', '~> 3.3'
  gem 'ruby-lsp', '~> 0.22.1'
  # solargraph doesn't support RBS 3.x
  # gem 'solargraph', '~> 0.50.0'
  gem 'stackprof', '~> 0.2.26'
end

group :test do
  gem 'rspec', '~> 3.13'
end

group :development, :test do
  gem 'rake', '~> 13.2', '>= 13.2.1'
end
