if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w(.. lib))

require 'rspec'
require 'rspec/its'
require 'quandl/operation'
require 'pry'
