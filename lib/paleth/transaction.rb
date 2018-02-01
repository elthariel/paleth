module Paleth
  # Repesents a transaction on an ethereum blockchain
  class Transaction
    def initialize(data)
      @data = data
    end

    SIMPLE_METHODS = %i(hash nonce block_hash block_number transaction_index
                        from to gas input)
    BIGDECIMAL_METHODS = %i(gas_price gas)

    SIMPLE_METHODS.each do |name|
      define_method name do
        @data.JS[name.camelize(false)]
      end
    end

    BIGDECIMAL_METHODS.each do |name|
      define_method name do
        value = @data.JS[name.camelize(false)]
        BigDecimal.new value if value
      end
    end

    def to_s
      data = [SIMPLE_METHODS + BIGDECIMAL_METHODS].flatten.map do |name|
        value = self.send(name)
        "#{name}=#{value}"
      end.join(', ')

      "Transaction(#{data})"
    end
  end
end
