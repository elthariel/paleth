require 'active_support/core_ext/string'
require 'json'

require 'paleth/helpers'
require 'paleth/liar'

module Paleth
  # Represents a contract instance deployed at a particular address
  class Contract
    attr_reader :contract, :address

    # :nodoc:
    # Create a contract instance
    def initialize(abi, contract, address)
      @abi = abi
      @contract = contract
      @address = address
    end

    # :nodoc:
    def self.at(core, abi, address)
      abi = JSON.parse(abi) if abi.is_a?(String)
      js_abi = `JSON.parse(#{abi.to_json})`

      contract = core.web3.JS[:eth].JS.contract(js_abi)
      instance = contract.JS.at(address)

      new(abi, instance, address)
    end

    # Returns the description of a given API call, or all of them if
    # no +name+ was requested or nil if the requested method wasn't
    # found.
    def abi(name = nil)
      if name.nil?
        @abi
      else
        @abi.find { |item| item['name'] == name }
      end
    end

    # Returns a proxy object on which contract methods are executed
    # locally using the `call` process
    def call
      @__caller ||= ContractCaller.new(self, true)
    end

    # Returns a proxy object on which contract methods are executed
    # via a transaction that is mined on the network
    def trx
      @__trx ||= ContractCaller.new(self, false)
    end
  end

  # Proxy class to execute transaction or calls on contract
  # methods. You can call any method that is part of the contract ABI.
  #
  # Those methods have the signature:
  #
  # method([arg1], [argn], [...], [transaction], [default_block])
  #
  # They return a Promise that resolves to the return value in the
  # case of a `call` method, or to the transaction hash in case of a
  # transaction method
  class ContractCaller
    include Paleth::Liar
    include Paleth::Helpers

    attr_reader :contract

    # :nodoc:
    def initialize(contract, call_mode = true)
      @contract = contract
      @call_mode = call_mode
    end

    def call?
      @call_mode
    end

    # :nodoc:
    def _process_trx(trx)
      if trx.is_a? Hash
        Paleth::Transaction.new(trx).to_n
      elsif trx.respond_to? :to_n
        trx.to_n
      else
        trx
      end
    end

    # Forwards method call to Contract. Returns a Promise
    def method_missing(name, *args)
      # Check method existence
      camel_name = name.camelize(false)
      abi = contract.abi(camel_name)
      raise NoMethodError, "Method #{name} not found" if abi.nil?

      # Check method arguments count
      processed_args = []
      method_arg_count = abi['inputs'].count
      if args.length < method_arg_count
        msg = "Method #{name} takes at least #{method_arg_count} arguments"
        raise ArgumentError, msg
      end

      # Pass the method arguments untouched
      method_arg_count.times { processed_args << args.shift }

      # Next argument should be a Transaction. Might also be the
      # defaultBlock parameter but we're not gonna touch it anyway, as
      # it's neither a transaction nor a Hash
      processed_args << _process_trx(args.shift) if args.length > 0

      # And finally the defaultBlock argument
      processed_args << args.shift if args.length > 0

      method = call? ? :call : :sendTransaction
      # puts "#{method}, #{name}, PROCESSED_ARGS = #{processed_args}, ARGS = #{args}"
      make_promise(@contract.contract.JS[camel_name], method, processed_args) do |result|
        if result.JS[:isBigNumber]
          to_bigdecimal(result)
        else
          result
        end
      end
    end
  end
end
