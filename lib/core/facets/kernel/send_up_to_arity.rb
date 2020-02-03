module Kernel
  # Conditionally send message only if args.length is within the min/max arity
  def send_if_arity_match(message, *args)
    arity = method(message).arity
    min_arity = arity >= 0 ? arity : -arity - 1
    max_arity = arity >= 0 ? arity : Float::INFINITY
    if args.length >= min_arity and args.length <= max_arity
      send(message, *args)
    end
  end

  # Receiver is expected to be a class (for instance_method to be defined). Still sends to the
  # receiver, but checks arity of instance_method(message) instead of method(message) (class
  # method).
  # Useful only when *class* method messages are delegated to *instance* methods using
  # method_missing/respond_to_missing?, which is what ActionMailer::Base does. Can't check
  # arity of Mailer.action directly because arity is always -1 for dynamic methods that exists only
  # due to respond_to_missing?.
  def send_if_instance_arity_match(message, *args)
    arity = instance_method(message).arity
    min_arity = arity >= 0 ? arity : -arity - 1
    max_arity = arity >= 0 ? arity : Float::INFINITY
    if args.length >= min_arity and args.length <= max_arity
      send(message, *args)
    end
  end

  # Send as many args as possible, up to the max arity
  # Useful if the message is dynamic and has variable arity and you always want to send the message,
  # but only want to send as many args as is allowed.
  # This may still result in error if args.length doesn't meet min arity.
  #
  def send_up_to_arity(message, *args)
    arity = method(message).arity
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
    send(message, *args_to_send)
  end
end


