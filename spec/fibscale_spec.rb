# frozen_string_literal: true

require 'nokogiri'
require 'rspec'
require 'spec_helper'

ENV['APP_ENV'] = 'test'

require './fibscale'

RSpec.describe 'FibScale' do
  def app
    Sinatra::Application
  end

  it 'shows the home page' do
    get '/'
    expect(last_response).to be_ok

    page = Nokogiri::HTML.parse(last_response.body)
    expect(page.css('title').text).to eq('FibScale')
    expect(page.css('#fib-number').first['value']).to eq('0')
  end

  it 'shows the home page without error even if the configured delay is invalid' do
    get '/', delay: 'foo'
    expect(last_response).to be_ok

    page = Nokogiri::HTML.parse(last_response.body)
    expect(page.css('title').text).to eq('FibScale')
    expect(page.css('#fib-number').first['value']).to eq('0')
  end

  it 'shows an error on the home page if the delay is badly configured' do
    get '/', delay: '-1'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Delay must be greater than or equal to zero.')
  end

  %w[recursive iterative].each do |algorithm|
    [{ n: 0, label: '0th', fib: 0 }, { n: 1, label: '1st', fib: 1 }, { n: 2, label: '2nd', fib: 1 },
     { n: 3, label: '3rd', fib: 2 }, { n: 4, label: '4th', fib: 3 }, { n: 5, label: '5th', fib: 5 },
     { n: 6, label: '6th', fib: 8 }, { n: 7, label: '7th', fib: 13 }, { n: 8, label: '8th', fib: 21 },
     { n: 9, label: '9th', fib: 34 }, { n: 10, label: '10th', fib: 55 }].each do |params|
      it "computes the #{params[:label]} fibonacci number with the #{algorithm} algorithm" do
        post '/', fib: params[:n], algorithm: algorithm
        expect(last_response).to be_ok
        expect(last_response.body).to include("The #{params[:label]} fibonacci number is:")

        page = Nokogiri::HTML.parse(last_response.body)
        expect(page.css('.fib-result').text).to eq(params[:fib].to_s)
      end
    end
  end

  it 'computes the 100th fibonacci number with the iterative algorithm' do
    post '/', fib: 100, algorithm: 'iterative'
    expect(last_response).to be_ok
    expect(last_response.body).to include('The 100th fibonacci number is:')

    page = Nokogiri::HTML.parse(last_response.body)
    expect(page.css('.fib-result').text).to eq('354,224,848,179,261,915,075')
  end

  it 'cannot compute a non-numeric fibonacci number' do
    post '/', fib: 'foo'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Fibonacci number must be an integer.')
  end

  it 'cannot compute a negative fibonacci number' do
    post '/', fib: -1
    expect(last_response).to be_ok
    expect(last_response.body).to include('Fibonacci number must be greater than or equal to zero.')
  end

  it 'cannot compute a fibonacci number with an unknown algorithm' do
    post '/', fib: 1, algorithm: 'foo'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Fibonacci algorithm must be one of: recursive, iterative.')
  end

  it 'cannot compute a fibonacci number higher than 40 with the recursive algorithm by default' do
    post '/', fib: 41
    expect(last_response).to be_ok
    expect(last_response.body).to include(
      'Cannot compute fibonacci numbers beyond 40 with the recursive algorithm (it would be too slow).'
    )
  end

  it 'cannot compute a fibonacci number higher than 10000 with the iterative algorithm by default' do
    post '/', fib: 10_001, algorithm: 'iterative'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Cannot compute fibonacci numbers beyond 10000.')
  end

  it 'cannot compute a fibonacci number with a negative delay' do
    post '/', fib: 1, delay: -2
    expect(last_response).to be_ok
    expect(last_response.body).to include('Delay must be greater than or equal to zero.')
  end
end
