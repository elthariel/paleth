require 'native'
require 'promise'

require 'paleth/db'
require 'paleth/eth'
require 'paleth/liar'
require 'paleth/net'
require 'paleth/personal'

module Paleth
  #
  # Main Paleth class
  #
  class Web3
    include Paleth::Liar

    attr_reader :web3
    # Initialize a Paleth:Web3 instance using a javascript `Web3` instance.
    # You shouldn't call this directly but use `Paleth.make` insteat
    def initialize(web3)
      @web3 = web3
    end

    def api_version
      web3.JS[:version].JS[:api]
    end

    def version(item)
      make_promise(web3.JS[:version], "get#{item.capitalize}")
    end

    def node_version
      version(:node)
    end

    def ethereum_version
      version(:ethereum)
    end

    def network_version
      version(:network)
    end

    def whisper_version
      version(:whisper)
    end

    # Check if a connection to a node exists
    def connected?
      web3.JS.isConnected
    end

    # Return the current instance provider
    def provider
      web3.JS.currentProvider
    end

    # Replace the current instance provider
    def provider=(new_provider)
      web3.JS.setProvider(new_provider)
      provider
    end

    # Should be called to reset state of web3. Resets everything
    # except manager. Uninstalls all filters. Stops polling.
    #
    # * +keep_is_syncing+ : If true it will uninstall all filters, but
    #   will keep the web3.eth.isSyncing() polls
    def reset!(keep_is_syncing = false)
      web3.JS.reset(keep_is_syncing)
    end

    def net
      @net ||= Paleth::Net.new(self)
    end

    def eth
      @eth ||= Paleth::Eth.new(self)
    end

    def personal
      @personal = Paleth::Personal.new(self)
    end

    def db(name)
      Paleth::Db.new(self, name)
    end
  end
end
