# frozen_string_literal: true

require 'rspec'
require 'rack/test'
require 'simplecov'

SimpleCov.start

RSpec.configure do |conf|
  conf.formatter = :documentation
  conf.include Rack::Test::Methods
end
