require 'promise'

module Paleth
  module Liar
    def make_promise(object, method_name, *args)
      promise = Promise.new

      callback = proc do |err, result|
        if err
          promise.reject err
        else
          result = yield result if block_given?
          promise.resolve result
        end
      end

      params = [args, callback].flatten
      object.JS[method_name].call(*params)

      promise
    end
  end
end
