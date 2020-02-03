require 'spec_helper'

describe Kernel do
  let(:obj) {
    klass = Class.new do
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
    klass.new
  }

  def arity(method_name)
    obj.method(method_name).arity
  end

  it 'send_if_arity_match' do
    expect(arity(:m_0)                         ).to eq 0
    expect(obj.send_if_arity_match(:m_0)       ).to eq 'called with 0 args'
    expect(obj.send_up_to_arity(   :m_0)       ).to eq 'called with 0 args'
    expect(obj.send_if_arity_match(:m_0, 1)    ).to eq nil
    expect(obj.send_up_to_arity(   :m_0, 1)    ).to eq 'called with 0 args'

    expect(arity(:m_1)                           ).to eq 1
    expect(obj.send_if_arity_match(:m_1)       ).to eq nil
    expect{obj.send_up_to_arity(   :m_1)       }.to raise_error('wrong number of arguments (given 0, expected 1)')
    expect(obj.send_if_arity_match(:m_1, 1)    ).to eq 'called with 1 args'
    expect(obj.send_up_to_arity(   :m_1, 1)    ).to eq 'called with 1 args'

    expect(arity(:m__1)                          ).to eq -1 # 0 required args
    expect(obj.send_if_arity_match(:m__1)      ).to eq 'called with 0 args'
    expect(obj.send_up_to_arity(   :m__1)      ).to eq 'called with 0 args'
    expect(obj.send_if_arity_match(:m__1, 1)   ).to eq 'called with 1 args'
    expect(obj.send_up_to_arity(   :m__1, 1)   ).to eq 'called with 1 args'
    expect(obj.send_if_arity_match(:m__1, 1, 2)).to eq 'called with 2 args'
    expect(obj.send_up_to_arity(   :m__1, 1, 2)).to eq 'called with 2 args'

    expect(arity(:m__2)                          ).to eq -2 # 1 required arg
    expect(obj.send_if_arity_match(:m__2)      ).to eq nil
    expect(obj.send_if_arity_match(:m__2, 1   )).to eq 'called with 1 args'
    expect(obj.send_up_to_arity(   :m__2, 1   )).to eq 'called with 1 args'
    expect(obj.send_if_arity_match(:m__2, 1, 2)).to eq 'called with 2 args'
    expect(obj.send_up_to_arity(   :m__2, 1, 2)).to eq 'called with 2 args'
  end
end
