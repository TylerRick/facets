require 'facets/functor'

module Kernel

  # Like #respond_to? but returns the result of the call if it does indeed respond.
  #
  # Like #respond from facets/kernel/respond but returns self (rather than nil) if it does not
  # respond to the given message.
  #
  # Examples:
  #
  #   class RespondExample
  #     def f; "f"; end
  #   end
  #
  #   x = RespondExample.new
  #   x.respond_or_self(:f)  #=> "f"
  #   x.respond_or_self(:g)  #=> x
  #
  # or
  #
  #   x.respond_or_self.f   #=> "f"
  #   x.respond_or_self.g   #=> x
  #
  # This allows you to simplify something verbose like this:
  #   value = options[:category].respond_to?(:to_db_value) ?
  #           options[:category].to_db_value :
  #           options[:category]
  #   if value == true
  #     ...
  #
  # into just this:
  #   if options[:category].respond_or_self.to_db_value == true
  #      ...
  #
  # CREDIT: Trans, Chris Wanstrath, Tyler Rick

  def respond_or_self(sym=nil, *args, &block)
    if sym
      return self if not respond_to?(sym)
      __send__(sym, *args, &block)
    else
      Functor.new do |method, *args, &block|
        if respond_to? method
          __send__(method, *args, &block)
        else
          self
        end
      end
    end
  end

end

