require 'simplecov'

SimpleCov.start do
  add_filter '/vendor'
end

require 'appdb_reader'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.order = 'random'
end
