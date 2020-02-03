covers 'facets/kernel/send_up_to_arity'

test_case Kernel do

  method :send_up_to_arity do
    c = Class.new do
      def m_0
        'called with 0 args'
      end

      def m_1(arg1)
        'called with 1 args'
      end

      def m__1(*args)
        "called with #{args.length} args"
      end

      def m__2(arg1, *args)
        "called with #{1 + args.length} args"
      end
    end

    obj = c.new
    define_method :arity do |method_name|
      obj.method(method_name).arity
    end

    test "it" do
      (arity(:m_0)                         ).assert == 0
      (obj.send_if_arity_match(:m_0)       ).assert == 'called with 0 args'
      (obj.send_up_to_arity(   :m_0)       ).assert == 'called with 0 args'
      (obj.send_if_arity_match(:m_0, 1)    ).assert == nil
      (obj.send_up_to_arity(   :m_0, 1)    ).assert == 'called with 0 args'

      (arity(:m_1)                         ).assert == 1
      (obj.send_if_arity_match(:m_1)       ).assert == nil
      ArgumentError.assert.raised? {
       obj.send_up_to_arity(   :m_1)       } #.to raise_error('wrong number of arguments (given 0, expected 1)')
      (obj.send_if_arity_match(:m_1, 1)    ).assert == 'called with 1 args'
      (obj.send_up_to_arity(   :m_1, 1)    ).assert == 'called with 1 args'

      (arity(:m__1)                        ).assert == -1 # 0 required args
      (obj.send_if_arity_match(:m__1)      ).assert == 'called with 0 args'
      (obj.send_up_to_arity(   :m__1)      ).assert == 'called with 0 args'
      (obj.send_if_arity_match(:m__1, 1)   ).assert == 'called with 1 args'
      (obj.send_up_to_arity(   :m__1, 1)   ).assert == 'called with 1 args'
      (obj.send_if_arity_match(:m__1, 1, 2)).assert == 'called with 2 args'
      (obj.send_up_to_arity(   :m__1, 1, 2)).assert == 'called with 2 args'

      (arity(:m__2)                        ).assert == -2 # 1 required arg
      (obj.send_if_arity_match(:m__2)      ).assert == nil
      (obj.send_if_arity_match(:m__2, 1   )).assert == 'called with 1 args'
      (obj.send_up_to_arity(   :m__2, 1   )).assert == 'called with 1 args'
      (obj.send_if_arity_match(:m__2, 1, 2)).assert == 'called with 2 args'
      (obj.send_up_to_arity(   :m__2, 1, 2)).assert == 'called with 2 args'
    end
  end
end

