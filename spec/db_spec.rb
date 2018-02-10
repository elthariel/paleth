require 'spec_helper'

RSpec.describe Paleth::Db do
  let(:w3) { Paleth.make(WEB3_OPTS) }
  let(:db) { w3.db('test_db') }

  it 'works' do
    pending 'api call not supported by Ganache'
    db.put_string('key', 'value')
    expect(db.get_string('key')).to eq 'value'
  end
end
