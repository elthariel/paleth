module Paleth
  # Repesents a transaction on an ethereum blockchain
  class TransactionReceipt
    def initialize(data)
      @data = data
    end

    SIMPLE_METHODS = %i(block_hash block_number transaction_hash
                        transaction_index from to cumulative_gas_user
                        gas_used contract_address logs status)
    SIMPLE_METHODS.each do |name|
      define_method name do
        @data.JS[name.camelize(false)]
      end
    end

    def success?
      status == 1
    end

    def failure?
      status.zero?
    end

    def to_s
      data = SIMPLE_METHODS.flatten.map do |name|
        value = self.send(name)
        "#{name}=#{value}"
      end.join(', ')

      "TransactionReceipt(#{data})"
    end
  end
end
