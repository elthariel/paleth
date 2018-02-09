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

    # Returns a Promise. Lock the account with the provided +address+
    def lock_account!(address)
      make_promise(@core.web3.JS[:personal], 'lockAccount', address)
    end

    # Create a new account using the provided +passphrase+. Returns
    # the new account address as a Promise.
    def new_account(passphrase)
      # `debugger`
      make_promise(@core.web3.JS[:personal], 'newAccount', passphrase)
    end

    # Sign the hex encoded +message+ with the requested +address+
    # (optionnaly unlocking the account with +password+)
    # Returns a Promise resolving to the requested data
    def sign(message, account, password = nil)
      args = [message, account, password].compact
      make_promise(@core.web3.JS[:personal], 'sign', *args)
    end

    # Recovers the account that signed the data. Returns the account
    # which signed as a Promise
    def ec_recover(signed_data, signature)
      make_promise(@core.web3.JS[:personal], 'ecRecover',
                   signed_data, signature)
    end
  end
end
