require 'paleth/helpers'
require 'paleth/liar'
require 'paleth/syncing'
require 'paleth/block'
require 'paleth/transaction'
require 'paleth/transaction_receipt'
require 'paleth/contract'

module Paleth
  # Ethereum blockchain related methods
  class Eth
    include Paleth::Liar
    include Paleth::Helpers

    # :nodoc:
    attr_reader :core

    # :nodoc:
    def initialize(core)
      @core = core
    end

    # Get the default address for:
    #
    # - sendTransaction
    # - call
    def default_account
      @core.web3.JS[:eth].JS[:defaultAccount]
    end

    # Set the default account, see default_account.
    def default_account=(addresss)
      @core.web3.JS[:eth].JS[:defaultAccount] = addresss
    end

    # Get the default block used for those calls
    #
    # - get_balance
    # - get_code
    # - get_transaction_count
    # - get_storage_at
    # - call
    # - contract.my_method.call()
    # - contract.my_method.estimate_gas()
    #
    # Supported values are:
    # - A block ID (Number)
    # - :earliest, the genesis block
    # - :latest, the head of the blockchain
    # - :pending, the currently mined block
    def default_block
      @core.web3.JS[:eth].JS[:defaultBlock]
    end

    # Set the default block, see default_block
    def default_block=(block)
      @core.web3.JS[:eth].JS[:defaultBlock] = block
    end

    # Returns a promis resolving to either false of a SyncState object
    def syncing_state
      make_promise(@core.web3.JS[:eth], 'getSyncing') do |result|
        result ? Paleth::SyncState.new(result) : result
      end
    end

    # Takes a block which will be call with 2 arguments everytime the syncing
    # status of the node changes:
    #
    # - +error+: nil or an error
    # - +sync+:
    #   - true when sync starts
    #   - A SyncState object when sync is ongoing
    #   - false when it stops
    def syncing(&_)
      @core.web3.JS[:eth].JS.isSyncing do |error, sync|
        sync = Paleth::SyncState.new(sync) if sync && sync != true
        yield error, sync
      end
    end

    # Returns a promise which resolve to the current coinbase
    def coinbase
      make_promise(@core.web3.JS[:eth], 'getCoinbase')
    end

    # Returns a promise which resolve true or false, depending on if
    # the client is currently mining or not
    def mining?
      make_promise(@core.web3.JS[:eth], 'getMining')
    end

    # Returns a promise which resolve to the current hashrate if client is mining
    def hashrate
      make_promise(@core.web3.JS[:eth], 'getHashrate')
    end

    # Returns a promise which resolve to the current gas price as a BigNumber in wei
    def gas_price
      make_promise(@core.web3.JS[:eth], 'getGasPrice') do |result|
        to_bigdecimal(result)
      end
    end

    # Returns a promise which resolves to an array of account addresses
    def accounts
      make_promise(@core.web3.JS[:eth], 'getAccounts') do |result|
        Native(`result`)
      end
    end

    # Returns a promise which resolves to the number of the most recent block
    def block_number
      make_promise(@core.web3.JS[:eth], 'getBlockNumber')
    end

    # Returns a promise which resolves to the balance of the account
    # with the requested +address+ at the given +block+. See default_block
    def balance(address, block = nil)
      args = [address, block].compact
      make_promise(@core.web3.JS[:eth], 'getBalance', *args) do |result|
        to_bigdecimal(result)
      end
    end

    # Returns a promise which resolves to the value stored at the
    # provided +address+ with the given +index+. Optionnaly you can
    # provide a block, or we'll use the default_block value
    def storage_at(address, index, block = nil)
      args = [address, index, block].compact
      make_promise(@core.web3.JS[:eth], 'getStorageAt', *args)
    end

    # Returns a promise which resolve to the code at the requested +address+.
    # You can optionnaly provide a +block+ number
    def code(address, block = nil)
      args = [address, block].compact
      make_promise(@core.web3.JS[:eth], 'getCode', *args)
    end

    # Returns a promise which resolve to a Block object representing
    # the block with the requested +number+.
    # +number+ can be a block number, :earliest, :latest or :pending
    def block(number, full = false)
      make_promise(@core.web3.JS[:eth], 'getBlock', number, full) do |block|
        Paleth::Block.new(block)
      end
    end

    # Same as +#block+ method, but get the uncle with the request index
    def uncle(number, index, full = false)
      make_promise(@core.web3.JS[:eth], 'getUncle', number, index, full) do |block|
        Paleth::Block.new(block)
      end
    end

    # Returns a promise which resolves to the number of transaction in
    # the requested block. Number has the same meaning as in the
    # +#block+ method
    def block_transaction_count(number)
      make_promise(@core.web3.JS[:eth], 'getBlockTransactionCount', number)
    end

    # Returns a promise which resolve to the Transaction object with the
    # requested hash
    def transaction(hash)
      make_promise(@core.web3.JS[:eth], 'getTransaction', hash) do |data|
        Paleth::Transaction.new data
      end
    end

    # Returns a promise which resolves to the transaction object with
    # the requested index in the requested block number, (or hash, or latest,
    # ..., see #block).
    def transaction_from_block(block, index)
      method = 'getTransactionFromBlock'
      make_promise(@core.web3.JS[:eth], method, block, index) do |data|
        Paleth::Transaction.new data
      end
    end

    # Returns a promise which resolves to the TransactionReceipt object for
    # the transaction with the requested +hash+
    def transaction_receipt(hash)
      make_promise(@core.web3.JS[:eth], 'getTransactionReceipt', hash) do |data|
        Paleth::TransactionReceipt.new data
      end
    end

    # Returns a promise which resolves to the number of transactions executed
    # from the requested +address+
    def transaction_count(address)
      make_promise(@core.web3.JS[:eth], 'getTransactionCount', address)
    end

    # Signs some +data+ using the account with the provided
    # +address+. The account has to be unlocked.
    # Returns a promise which resolves to the signed data
    def sign(address, data)
      puts 'Warning: Eth#sign is deprecated and mostly does not work. ' \
           'Use Personal#sign'
      make_promise(@core.web3.JS[:eth], 'sign', address, data)
    end

    # Sends a transaction to the network. Returns a promise which resolves to
    # the transaction hash.
    # Transaction can either be a Transaction object, or a hash which is
    # converted to to a native javascript object (the key names aren't changed)
    def send_transaction(trans)
      make_promise(@core.web3.JS[:eth], 'sendTransaction', trans.to_n)
    end

    # Sends an already signed transaction to the network. Returns a
    # promise which resolves to the transaction hash.
    def send_raw_transaction(signed_transaction_data)
      make_promise(@core.web3.JS[:eth], 'sendRawTransaction',
                   signed_transaction_data)
    end

    # Executes a message call transaction, which is directly executed
    # in the VM of the node, but never mined into the blockchain.
    # Returns a promise with resolve to the call return value
    def call(trans, block = nil)
      args = [trans, block].compact
      make_promise(@core.web3.JS[:eth], 'call', *args)
    end

    # Executes a message call or transaction, which is directly
    # executed in the VM of the node, but never mined into the
    # blockchain and returns the amount of the gas used.
    # Estimated gas value is returned as a promise
    def estimate_gas(trans)
      make_promise(@core.web3.JS[:eth], 'call', trans)
    end

    # Create a contract object, which can then be used to instantiate
    # a contract at a particular address
    # @param abi String The abi array of the contract
    def contract(abi, address)
      Paleth::Contract.at(@core, abi, address)
    end
  end
end
