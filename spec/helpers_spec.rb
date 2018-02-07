require 'spec_helper'
require 'paleth/helpers'

class Helpers
  class << self
    include Paleth::Helpers
  end
end

RSpec.describe Paleth::Helpers do
  describe '#sha3' do
    it 'produces a sha3 hash' do
      expect(Helpers.sha3('lol'))
        .to eq('0xf172873c63909462ac4de545471fd3ad3e9eeadeec4608b92d16ce6b500704cc')
    end
  end

  describe '#to_hex' do
    it 'produces a hex string' do
      expect(Helpers.to_hex(0x42)).to eq('0x42')
    end
  end

  describe '#to_ascii' do
    it 'converts back to a string from an hex representation' do
      expect(Helpers.to_ascii(Helpers.to_hex('lol'))).to eq('lol')
    end
  end

  describe '#from_ascii' do
    it 'works' do
      expect(Helpers.from_ascii('string')).to eq('0x737472696e67')
    end
  end

  describe '#to_decimal' do
    it 'works' do
      expect(Helpers.to_decimal('0xff')).to eq(255)
    end
  end

  describe '#to_decimal' do
    it 'works' do
      expect(Helpers.from_decimal(255)).to eq('0xff')
    end
  end

  describe '#from_wei' do
    it 'works' do
      res = Helpers.from_wei(1000, 'kwei')
      expect(res).to eq(1)
      expect(res).to be_a(BigDecimal)
    end
  end

  describe '#to_wei' do
    it 'works' do
      res = Helpers.to_wei(1, :kwei)
      expect(res).to eq(1000)
      expect(res).to be_a(BigDecimal)
    end
  end

  describe '#address?' do
    it 'works' do
      expect(Helpers.address?('0x42')).to be false
      expect(Helpers.address?('0x493cc4021a0e63fc4185782f6d14bb722d992837')).to be true
    end
  end

  describe '#to_bigdecimal' do
    it 'converts strings to bigdecimal' do
      expect(Helpers.to_bigdecimal('1234')).to eq(1234)
      expect(Helpers.to_bigdecimal('1234')).to be_a(BigDecimal)
    end

    it 'converts numbers to bigdecimal' do
      expect(Helpers.to_bigdecimal(1.234)).to eq(1.234)
      expect(Helpers.to_bigdecimal(1234)).to be_a(BigDecimal)
    end

    it 'returns other types untouched' do
      expect(Helpers.to_bigdecimal(Helpers)).to be Helpers
    end
  end
end
