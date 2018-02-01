require 'paleth/liar'

module Paleth
  # Wrapper for the `personal` management API
  class Personal
    include Paleth::Liar

    attr_reader :core

    def initialize(core)
      @core = core
    end

    # Returns the list of accounts as a Promis.
    def accounts
      make_promise(@core.web3.JS[:personal], 'getListAccounts')
    end

    # Returns a Promise. Unlock the account with the provided +address+
    # using the provided +passphrase+ for +duration+ seconds.
    def unlock_account!(address, passphrase = nil, duration = nil)
      args = [address, passphrase, duration].compact
      make_promise(@core.web3.JS[:personal], 'unlockAccount', *args)
    end

    # Sign the hex encoded +message+ with the requested +address+
    # (optionnaly unlocking the account with +password+)
    # Returns a Promise resolving to the requested data
    def sign(message, account, password = nil)
      args = [message, account, password].compact
      make_promise(@core.web3.JS[:personal], 'sign', *args)
    end
  end
end
