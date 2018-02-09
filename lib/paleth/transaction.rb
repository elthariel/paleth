require 'active_support/core_ext/string'

module Paleth
  # Repesents a transaction on an ethereum blockchain
  class Transaction
    attr_reader :object

    def initialize(object = {})
      if object.is_a? Hash
        @object = object.each_with_object({}) do |(key, value), hash|
          hash[key.camelize(false)] = value
        end.to_n
      else
        @object = object
      end
    end

    SIMPLE_METHODS = %i(hash nonce block_hash block_number transaction_index
                        from to input data)
    BIGDECIMAL_METHODS = %i(gas_price gas)

    SIMPLE_METHODS.each do |name|
      define_method name do
        @object.JS[name.camelize(false)]
      end

      define_method "#{name}=" do |value|
        @object.JS[name.camelize(false)] = value
      end
    end

    BIGDECIMAL_METHODS.each do |name|
      define_method name do
        value = @object.JS[name.camelize(false)]
        BigDecimal.new value if value
      end

      define_method "#{name}=" do |value|
        value = BigDecimal.new value
        @object.JS[name.camelize(false)] = Paleth.to_bigdecimal(value).bignumber
      end
    end

    def to_s
      data = [SIMPLE_METHODS + BIGDECIMAL_METHODS].flatten.map do |name|
        value = self.send(name)
        "#{name}=#{value}"
      end.join(', ')

      "Transaction(#{data})"
    end

    def to_n
      object
    end
  end
end
