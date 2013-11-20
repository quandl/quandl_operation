if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require "quandl/operation"
require 'pry'