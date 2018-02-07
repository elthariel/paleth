require 'spec_helper'

RSpec.describe Paleth do
  describe '#make' do
    it 'builds a Web3 object' do
      web3 = Paleth.make(WEB3_OPTS)

      expect(web3).to be_a(Paleth::Web3)
      expect(web3.api_version).to be_a(String)
    end
  end
end

RSpec.describe Paleth::Web3 do
  let(:web3) { Paleth.make(WEB3_OPTS) }

  describe '#api_version' do
    it 'returns a String' do
      expect(web3.api_version).to be_a(String)
      expect(web3.api_version).to match(/\d+\.\d+.*/)
    end
  end

  describe '#version' do
    VERSION_NAMES = %i(node ethereum network whisper)

    it 'returns a Promise' do
      VERSION_NAMES.each do |name|
        expect(web3.version(name)).to be_a(Promise)
      end
    end

    async 'resolves to a String' do
      VERSION_NAMES.each do |name|
        web3.version(name).then do |result|
          run_async { expect(result).to be_a(String) }
        end
      end
    end
  end

  describe '#connected?' do
    it 'returns a boolean' do
      expect(web3.connected?).to be true
    end
  end

  describe '#net' do
    it 'returns a Paleth::Net object' do
      expect(web3.net).to be_a(Paleth::Net)
      expect(web3.net.core).to eq(web3)
    end
  end

  describe '#eth' do
    it 'returns a Paleth::Eth' do
      expect(web3.eth).to be_a(Paleth::Eth)
      expect(web3.eth.core).to eq(web3)
    end
  end

  describe '#personal' do
    it 'returns a Paleth::Personal' do
      expect(web3.personal).to be_a(Paleth::Personal)
      expect(web3.personal.core).to eq(web3)
    end
  end

  describe '#db' do
    it 'returns a Paleth::Db' do
      expect(web3.db('fuck')).to be_a(Paleth::Db)
      expect(web3.db('fuck').core).to eq(web3)
    end
  end
end
