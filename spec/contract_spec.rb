require 'spec_helper'
require 'fixtures/contracts'

RSpec.describe 'Contracts' do
  let(:w3) { Paleth.make(WEB3_OPTS) }
  let(:eth) { w3.eth }

  subject do
    promise = Promise.new

    eth.accounts.then do |accounts|
      trans = Paleth::Transaction.new
      trans.from = accounts[0]
      trans.data = CONTRACTS[:simple_storage][:bin]
      trans.gas = 1_000_000

      eth.send_transaction(trans).then do |trx_hash|
        eth.transaction_receipt(trx_hash).then do |receipt|
          contract = eth.contract(CONTRACTS[:simple_storage][:abi],
                                  receipt.contract_address)
          promise.resolve contract: contract, address: accounts[1]
        end
      end
    end.fail do |error|
      promise.reject error
    end

    promise
  end


  async 'can make calls' do
    subject[:contract].call.get.then do |value|
      run_async do
        expect(value).to be_a(BigDecimal)
        expect(value).to eq(0)
      end
    end
  end

  async 'can make transactions' do
    eth.accounts.then do |accounts|
      subject[:contract].trx.set(42, from: accounts[0], gas: 1_000_000).then do |trx_res|
        subject[:contract].call.get.then do |value|
          run_async do
            expect(value).to be_a(BigDecimal)
            expect(value).to eq(42)
          end
        end
      end
    end
  end
end
