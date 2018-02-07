require 'spec_helper'

RSpec.describe Paleth do
  describe 'Constants' do
    it 'has a version number' do
      expect(Paleth::VERSION).not_to be nil
    end

    it 'has DEFAULT_HTTP_PROVIDER' do
      expect(Paleth::DEFAULT_HTTP_PROVIDER).to match(/^http/)
    end

    it 'has UNITS' do
      expect(Paleth::UNITS).not_to be nil
      Paleth::UNITS.each do |unit|
        expect(unit).to be_a Symbol
      end
    end
  end
end
