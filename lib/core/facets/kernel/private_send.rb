require 'facets/functor'

module Kernel

  # Allows you to call a private method directly on the given object.
  #
  #   class Thing
  #     private def secret
  #       'secret'
  #     end
  #   end
  #
  #   Thing.new.send_private.secret  #=> 'secret'
  #
  # Compare to:
  # - #public_send
  # - #try      (facets/kernel/try.rb)
  # - #respond  (facets/kernel/respond.rb)
  # - #not_send (facets/kernel/not.rb)
  #
  def private_send(method=nil, *args, &block)
    if method
      __send__(method, *args, &block)
    else
      Functor.new do |method, *args, &block|
        __send__(method, *args, &block)
      end
    end
  end
end
