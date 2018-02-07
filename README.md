# Paleth

[![Build Status](https://travis-ci.org/elthariel/paleth.svg?branch=master)](https://travis-ci.org/elthariel/paleth)

Paleth (Opal + Ethereum) is a simple wrapper around ethereum's web3.js
DApp libray, that provide a Ruby friendly API while staying as close
as possible to the orignal web3.js API.

Paleth returns Opal's Promise to most of its calls.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paleth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paleth

## Usage

``` ruby
require 'paleth'

#
# Initialize a Paleth::Web3 instance (main object)
#

# Use the global web3.currentProvider (Mist)
w3 = Paleth.make
# Specifically provide a Web3 instance
w3 = Paleth.make(web3: `window.Web3`)
# Provide an RPC address
w3 = Paleth.make(http: 'http://localhost:8545')

#
# Use it
#
w3.eth.coinbase.then do |coinbase|
  puts coinbase
end.fail do |error|
  puts "Unable to get Coinbase: #{error}"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/elthariel/paleth.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
