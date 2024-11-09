# frozen_string_literal: true

source 'https://rubygems.org'

# Web framework (http://sinatrarb.com)
gem 'rackup', '~> 2.2'
gem 'sinatra', '~> 4.0'

group :development do
  # Code formatting & linting
  gem 'rubocop', '~> 1.22', require: false

  # Sinatra utilities (e.g. live reload)
  gem 'sinatra-contrib', '~> 4.0'
end

group :production do
  # Ruby web server (https://puma.io)
  gem 'puma', '~> 6.0'
end
