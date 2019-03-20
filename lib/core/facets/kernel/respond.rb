require 'facets/functor'

module Kernel

  # TODO: Should Kernel#respond be moved to functor gem?

  # Like #respond_to? but returns the result of the call
  # if it does indeed respond.
  #
  #   class RespondExample
  #     def f; "f"; end
  #   end
  #
  #   x = RespondExample.new
  #   x.respond(:f)  #=> "f"
  #   x.respond(:g)  #=> nil
  #
  # This method was known as #try until Rails defined #try
  # to be something more akin to #ergo.
  #
  # CREDIT: Chris Wanstrath

  # TODO: either check for private/protected methods by default, or let you pass true to have it
  # also include private methods (same as respond_to? :sym, true works)
  # respond(true).resource&.name || breadcrumbs.last&.name,

  def respond(sym=nil, *args, &blk)
    case sym
    when Symbol, String
      return nil if not respond_to?(sym)
      __send__(sym, *args, &blk)
    #when true, false
      #  # somehow pass this arg to Functor.new?
    else
      Functor.new(&method(:respond).to_proc)
    end
  end

end
