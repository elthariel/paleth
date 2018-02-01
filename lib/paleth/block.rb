module Paleth
  # Represents an ethereum transaction block.
  class Block
    def initialize(data)
      @data = data
    end

    SIMPLE_METHODS = %i(number hash parent_hash nonce sha3_uncles logs_bloom
                        transactions_root state_root miner extra_data size
                        gas_limit gas_used timestamp transactions uncles)
    BIGDECIMAL_METHODS = %i(difficulty total_difficulty)

    SIMPLE_METHODS.each do |name|
      define_method name do
        @data.JS[name.camelize(false)]
      end
    end

    BIGDECIMAL_METHODS.each do |name|
      define_method name do
        BigDecimal.new @data.JS[name.camelize(false)]
      end
    end

    def to_s
      data = [SIMPLE_METHODS + BIGDECIMAL_METHODS].flatten.map do |name|
        value = self.send(name)
        "#{name}=#{value}"
      end.join(', ')

      "Block(#{data})"
    end
  end
end
