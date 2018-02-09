# Paleth

[![Build Status](https://travis-ci.org/elthariel/paleth.svg?branch=master)](https://travis-ci.org/elthariel/paleth)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/elthariel/paleth/master)
[![License](https://img.shields.io/github/license/elthariel/paleth.svg)](https://github.com/elthariel/paleth/blob/master/LICENSE)


Paleth (Opal + Ethereum) is a simple wrapper around ethereum's web3.js
DApp libray, that provide a Ruby friendly API while staying as close
as possible to the orignal web3.js API.

It was initially developped for the Mist client, which only supports
asynchronous calls. Paleth hence only support async calls variants and
returns Opal's Promises for most of its calls


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

## TODO

- [ ] All basic API
  - [x] web3.net
  - [x] web3.eth (everything except filters)
  - [x] web3.db
  - [ ] web3.personal (partial, only accounts/unlock/sign)
- [ ] Filter
- [ ] Contract support
  - [x] Instantiated wrapper with call() and sendTransaction()
  - [ ] Events
  - [ ] Contract creation via Paleth::Contract



## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/elthariel/paleth.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
