module Whisperer
  module Helpers
    def add_builder(meth_id)
      mod = Module.new

      mod.instance_eval do
        define_method(meth_id) do |*args|
          obj = new(*args)
          obj.public_send(meth_id)
        end
      end

      extend mod
    end
  end
end