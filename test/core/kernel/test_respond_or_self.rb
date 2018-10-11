covers 'facets/kernel/respond_or_self'

test_case Kernel do

  method :respond_or_self do

    test do
      klass = Class.new do
        def m
          'm'
        end

        def just_yield
          yield
        end
      end
      obj = klass.new
      obj.respond_or_self(:m).   assert == 'm'
      obj.respond_or_self. m.    assert == 'm'
      obj.respond_or_self(:bark).assert == obj
      obj.respond_or_self. bark. assert == obj

      obj.respond_or_self(:just_yield) { 'yielded' }.assert == 'yielded'
      obj.respond_or_self. just_yield  { 'yielded' }.assert == 'yielded'
      obj.respond_or_self(:just_bark)  { 'yielded' }.assert == obj
      obj.respond_or_self. just_bark   { 'yielded' }.assert == obj
    end

  end

end

