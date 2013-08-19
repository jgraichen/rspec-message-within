# Bundler setup
require 'bundler'
Bundler.setup :default, :test

require 'rspec/autorun'
require 'rspec/message/within'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec do |c|
    # Only allow expect syntax
    c.syntax = :expect
  end
end
