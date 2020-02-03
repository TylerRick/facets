class Proc
  # compare to lib/core/facets/kernel/send_if_arity_match.rb
  def call_up_to_arity(*args)
    max_arity = arity >= 0 ? arity : Float::INFINITY
    # If max_arity is 0, can't send any args
    if max_arity.zero?
      args_to_send = []
    # If max_arity is 1,    can send args 0 .. 0
    # If max_arity is 2,    can send args 0 .. 1
    # If max_arity is infinite, send args 0 .. -1 (all of them)
    else
      highest_index = max_arity.infinite? ? -1 : max_arity - 1
      args_to_send = args[0 .. highest_index]
    end
    call(*args_to_send)
  end
end
