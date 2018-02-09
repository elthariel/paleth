require 'spec_helper'

RSpec.describe Paleth::Transaction do
  let(:raw_data) do
    {
      hash: 'hash',
      nonce: 42,
      blockHash: 'blockHash',
      blockNumber: 1,
      transactionIndex: 42,
      from: '0x493cc4021a0e63fc4185782f6d14bb722d992837',
      to: '0x4437385b411655638a663b35c556c5671a601e2d',
      gas: 1234,
      gasPrice: 2323
    }
  end
  subject { Paleth::Transaction.new raw_data }

  it 'provides access to wrapped JS object' do
    expect(JS.typeof(subject.object)).to eq 'object'
  end

  it 'provides accessors' do
    expect(subject.hash).to eq 'hash'
    expect(subject.nonce).to eq 42
    expect(subject.block_hash).to eq 'blockHash'
    expect(subject.block_number).to eq 1
    expect(subject.gas_price).to eq 2323
  end
end
