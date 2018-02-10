require 'paleth/liar'

module Paleth
  # Wraps a local leveldb database
  # FIXME: I've been developping using Mist which doesn't seem to
  # support the db_xxx API
  class Db
    include Paleth::Liar

    attr_reader :core, :db_name

    def initialize(core, db_name)
      @core = core
      @db_name = db_name
    end

    %i(string hex).each do |type|
      define_method "put_#{type}" do |key, value|
        @core.web3.JS[:db].JS["put#{type.capitalize}"].call(
          db_name, key, value
        )
      end

      define_method "get_#{type}" do |key|
        @core.web3.JS[:db].JS["get#{type.capitalize}"].call(
          db_name, key
        )
      end
    end
  end
end
