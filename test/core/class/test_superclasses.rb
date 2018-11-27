covers 'facets/class/superclasses'

test_case Class do

  method :superclasses do
    test do
      c  = Class.new
      c1 = Class.new(c)
      c2 = Class.new(c1)
      c2.include Enumerable

      c2.superclass.  assert == c1
      c2.superclasses.to_set.assert.subset? c2.ancestors.to_set
      c2.superclasses.assert == [c1, c, Object, BasicObject]
      # In contrast to ancestors, which also includes these modules:
      c2.ancestors.assert.include? Kernel
      c2.ancestors.assert.include? Enumerable
    end

    test do
      Array.superclasses.assert == [Object, BasicObject]
      Array.ancestors.   assert == [Array, Enumerable, Object, AE::Expect, AE::Assert, Kernel, BasicObject]
    end

    test do
      SimpleDelegator.superclasses.assert == [Delegator, BasicObject]
    end
  end

end
