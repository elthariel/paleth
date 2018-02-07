require 'web3'
require 'paleth'
require 'opal/rspec/fixes'

WEB3_OPTS = { http: 'http://localhost:4285' }

unless Paleth.make(WEB3_OPTS).connected?
  raise 'Please install and run ganache-cli: ganache-cli -p 4285'
end

RSpec.configure do |config|
end
