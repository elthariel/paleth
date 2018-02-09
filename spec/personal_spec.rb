require 'spec_helper'

RSpec.describe Paleth::Personal do
  let(:pass) { 'letshavealongenoughpassphrase' }
  let(:w3) { Paleth.make(WEB3_OPTS) }

  subject! do
    promise = Promise.new

    w3.personal.new_account(pass).then do |address|
      promise.resolve address
    end.fail do |error|
      puts "Unable to create an account: #{error}"
      promise.reject error
    end

    promise
  end

  describe '#new_account' do
    it 'returns an address' do
      expect(subject).to be_a(String)
      expect(subject).to match(/0x[0-9a-f]+/)
    end
  end
end
