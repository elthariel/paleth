if RUBY_ENGINE != 'opal'
  require 'opal'
  require 'opal-activesupport'

  require 'paleth/version'
  # Adds web3.js to Sprockets asset path
  require 'paleth/rails' if defined?(::Rails)

  Opal.append_path File.expand_path('..', __FILE__).untaint
else
  require 'js'
  require 'console'

  require_relative 'paleth/version'
  require_relative 'paleth/helpers'
  require_relative 'paleth/web3'

  if JS.typeof(`Web3`) == 'undefined'
    $console.error "Cannot find 'Web3', please add web3.js"
  end

  module Paleth
    DEFAULT_HTTP_PROVIDER = 'http://localhost:8545'
    UNITS = %i(
      kwei
      ada
      mwei babbage
      gwei shannon
      szabo
      finney
      ether
      kether grand einstein
      mether
      gether
      tether
    )

    class << self
      include Helpers
    end

    #
    # Create a Paleth web instance. Without any arguments, it'll try
    # to initialize using `web3.currentProvider`, or you can
    # initialize it manually by providing the following keyword
    # arguments:
    #
    # [web3] An initialized web3 instance
    # [http] The url to an ethereum json rpc server
    #
    def self.make(opts = {})
      Paleth::Web3.new(_web3_from(opts))
    end

    def self._web3_from(opts)
      if opts.key? :web3
        opts[:web3]
      elsif opts.key? :http
        `new Web3(new Web3.providers.HttpProvider(#{opts[:http]}))`
      elsif `typeof(web3)` != 'undefined'
        `new Web3(web3.currentProvider)`
      else
        msg = "No provider given and no global 'web3' object. " +
              "Using http provider with default url: #{DEFAULT_HTTP_PROVIDER}"
        $console.warn msg
        `new Web3.providers.HttpProvider(#{DEFAULT_HTTP_PROVIDER})`
      end
    end

    def self.test
      p = make
      puts "Web3 API version = #{p.api_version}"
      %i(node ethereum network whisper).each do |item|
        p.version(item).then do |version|
          puts "#{item} version = #{version}"
        end.fail do |error|
          puts error
        end
      end

      puts "Connected: #{p.connected?}"
      puts "SHA3: #{sha3('Opal is cool')}"

      str = "Hello Opal !"
      hex = to_hex(str)
      puts to_ascii(hex)

      p.net.listening.then do |listening|
        puts "Currently listening: #{listening}"
      end.fail do |error|
        puts error
      end

      p.net.peer_count.then do |count|
        puts "Peer Count: #{count}"
      end.fail do |error|
        puts error
      end

      db = p.db('_test_')
      db.put_string('hello', 'world').then do
        db.get_string('hello').then do |result|
          puts "db.get('hello') => #{result}"
        end.fail do |error|
          puts error
        end
      end.fail do |error|
        puts error
      end

      puts "Default account = #{p.eth.default_account}"
      puts "Default block = #{p.eth.default_block}"

      p.eth.coinbase.then do |coinbase|
        puts "Coinbase: #{coinbase}"
      end.fail do |error|
        puts error
      end

      p.eth.mining?.then do |result|
        puts "Mining? #{result}"
      end.fail do |error|
        puts error
      end

      p.eth.hashrate.then do |result|
        puts "Hashrate: #{result}"
      end.fail do |error|
        puts error
      end

      p.eth.gas_price.then do |result|
        puts "Gas Price: #{result}"
      end.fail do |error|
        puts error
      end

      p.eth.accounts.then do |result|
        puts "Acounts: #{result}"

        p.eth.balance(result[0]).then do |balance|
          puts "Account Balance: #{balance}"
        end.fail do |error|
          puts error
        end

      end.fail do |error|
        puts error
      end

      p.eth.block_number.then do |result|
        puts "Last Block number: #{result}"
      end.fail do |error|
        puts error
      end

      p.eth.syncing_state.then do |result|
        puts "Syncing state: #{result}"
      end.fail do |error|
        puts error
      end

      p.eth.syncing do |error, sync|
        puts "Syncing: (err=#{error}, (sync=#{sync}))"
      end

      addr = '0x6d5ae9dd8f1a2582deb1b096915313459f11ba70'
      p.eth.code(addr).then do |result|
        puts "Code: #{result[0..42]}"
      end.fail do |error|
        puts error
      end

      p.eth.block(:latest, true).then do |result|
        puts result
      end.fail do |error|
        puts error
      end

      hash = '0x8883605a5f08e5e8feb24cb1a30fc1a2d56d624bb22cc930145f70bb1bbc8c88'
      p.eth.transaction(hash).then do |result|
        puts result
      end.fail do |error|
        puts error
      end

      p.eth.transaction_receipt(hash).then do |result|
        puts result
      end.fail do |error|
        puts error
      end

      addr = '0x726c79ff9BcbB3A916A01423355D2bc779d03873'
      p.eth.transaction_count(addr).then do |result|
        puts "Transaction count for #{addr} = #{result}"
      end.fail do |error|
        puts error
      end


      data = to_hex "La chair est triste, helas !"
      p.eth.accounts.then do |accounts|
        puts "List accounts: #{accounts}"
        p.personal.sign(data, accounts[0]).then do |result|
          puts "Signed data = #{result}"
        end.fail do |error|
          puts error
        end
      end.fail do |error|
        puts error
      end

    end
  end
end
