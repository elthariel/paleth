require 'bigdecimal'

module Paleth
  #
  # Various data format helpers provided by web3.js
  #

  # :nodoc:
  #
  # In the web3.js library, those helpers are part of the web3
  # instance, but it doesn't seem very idiomatic ruby so we're going
  # to have a dummy singleton instance of web3 to provide those services
  # globally
  def self._dummy_web3
    @__dummy_web3 ||= `new Web3(new Web3.providers.HttpProvider('http://dummy'))`
  end

  # Various helpers to handle web3.js data transformations
  module Helpers
    # Returns a provided +string+ hashed using the Keccak-256 SHA3 algorithm
    #
    # You can optionnaly provide the the `encoding: 'hex'` option if
    # the string is encoded in hexadecimal
    def sha3(string, opts = {})
      Paleth._dummy_web3.JS.sha3(string, opts)
    end

    # Converts any value into a string hexadecimal representation
    def to_hex(value)
      Paleth._dummy_web3.JS.toHex(from_bigdecimal(value))
    end

    # Converts back an hexadecimal representation of a string into the ascii
    # representation of the string
    def to_ascii(hex_string)
      Paleth._dummy_web3.JS.toAscii(hex_string)
    end

    # Converts an ascii string to its hexadecimal representation with
    # optional padding
    #
    # * +str+: The string to be converted
    # * +bytes+: The number of bytes of the returned string should have.
    #   Padding will be added at the end if needed
    def from_ascii(str, bytes = nil)
      Paleth._dummy_web3.JS.fromAscii(str, bytes)
    end

    # Converts an hexadecimal string to its decimal representation
    def to_decimal(hex)
      Paleth._dummy_web3.JS.toDecimal(hex)
    end

    # Converts a decimal to its hexadecimal string representation
    def from_decimal(number)
      Paleth._dummy_web3.JS.fromDecimal(from_bigdecimal(number))
    end

    # Converts a value in Wei to any supported unit, see Paleth::UNITS
    def from_wei(number, unit)
      raise "Unsupported unit #{unit}" unless Paleth::UNITS.include?(unit)

      to_bigdecimal(Paleth._dummy_web3.JS.fromWei(from_bigdecimal(number),
                                                  unit))
    end

    # Converts a value from any supported unit (see Paleth::UNITS) in Wei
    def to_wei(number, unit)
      raise "Unsupported unit #{unit}" unless Paleth::UNITS.include?(unit)

      to_bigdecimal(Paleth._dummy_web3.JS.toWei(from_bigdecimal(number),
                                                unit))
    end

    # Converts a JS Number, BigNumber, or Hex string into a ruby BigDecimal
    # If it's neither a String, a Number or a BigNumber, just returns the value
    # untouched
    def to_bigdecimal(number)
      type = JS.typeof(number)
      is_big_number = number.JS[:isBigNumber]
      if type == 'number' || is_big_number
        BigDecimal.new number
      elsif type == 'string'
        BigDecimal.new Paleth._dummy_web3.JS.toBigNumber(number)
      else
        number
      end
    end

    # Converts a ruby BigDecimal to a JS BigNumber, or pass the value untouched
    def from_bigdecimal(number)
      if number.is_a? BigDecimal
        number.bignumber
      else
        number
      end
    end

    # returns true if the value is a valid ethereum address, false otherwise
    def address?(hex)
      Paleth._dummy_web3.JS.isAddress(hex)
    end
  end
end
