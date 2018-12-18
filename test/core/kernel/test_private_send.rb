covers 'facets/kernel/private_send'

test_case Kernel do
  method :private_send do
    def struct
      Struct.new(:name).new('bob')
    end

    test do
      struct.private_send(:name).assert == 'bob'
    end

    test do
      struct.private_send.name.assert == 'bob'
    end

    def klass_with_secret
      Class.new do
        def initialize
          @secret = 'secret'
        end

        private
          attr_accessor :secret
      end
    end

    test do
      object = klass_with_secret.new
      NoMethodError.assert.raised? { object.secret }
      object.private_send(:secret).assert == 'secret'
      object.private_send.secret.assert == 'secret'
    end

    test do
      object = klass_with_secret.new
      NoMethodError.assert.raised? { object.secret = 'new secret' }
      object.private_send.secret = 'new secret'
      object.private_send.secret.assert == 'new secret'
    end
  end
end
