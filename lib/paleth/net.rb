require 'paleth/liar'

module Paleth
  # Provide some data about the underlying network status
  class Net
    include Paleth::Liar

    # :nodoc:
    attr_reader :core

    # :nodoc:
    def initialize(core)
      @core = core
    end

    # Returns a Promise resolving to true or false whether the client
    # is listening for connections
    def listening
      make_promise(@core.web3.JS[:net], 'getListening')
    end

    # Returns a Promise resolving to the current peer count
    def peer_count
      make_promise(@core.web3.JS[:net], 'getPeerCount')
    end
  end
end
