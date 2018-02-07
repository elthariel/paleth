require 'spec_helper'

RSpec.describe Paleth::Net do
  subject { Paleth.make(WEB3_OPTS).net }

  describe '#listening' do
    async 'returns whether we are listening for connections' do
      subject.listening.then do |result|
        run_async { expect(result).to be true }
      end
    end
  end

  describe '#peer_count' do
    async 'returns the number of peers' do
      subject.peer_count.then do |res|
        run_async { expect(res).to eq 0 }
      end
    end
  end
end
