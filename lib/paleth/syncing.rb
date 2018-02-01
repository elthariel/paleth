module Paleth
  # Represents the Synchronization state of the ethereum client with
  # the network
  class SyncState
    attr_reader :state

    # :nodoc:
    def initialize(state)
      @state = state
    end

    # The block number where the sync started.
    def starting
      @state.JS[:startingBlock]
    end

    # The block number where at which block the node currently synced
    # to already.
    def current
      @state.JS[:currentBlock]
    end

    #  The estimated block number to sync to
    def highest
      @state.JS[:highestBlock]
    end

    # Pretty printer
    def to_s
      "SyncState(starting=#{starting}, current=#{current}, highest=#{highest})"
    end
  end
end
