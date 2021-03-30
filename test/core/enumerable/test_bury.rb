covers 'facets/hash/bury'
covers 'facets/array/bury'
covers 'facets/enumerable/set_at_path'

require 'facets/enumerable/bury'

# Asserts that we can dig at the same path where we buried the treasure and find it there
def assert_diggable(o, path)
  o.bury(*path,           :value)
  o.dig( *path).assert == :value
end

test_case Array do
  method :bury do
    test "can't use non-Integer as an index into an array" do
      path = ['bear']
      TypeError.assert.raised? { [].bury(:users, 0) }
      TypeError.assert.raised? { [].bury(:users, 0, 'Matz') }
      # The alternative would be to add an extra level of nesting (self << { key => value }), which
      # is what dam13n's original version did, but:
      # 1. It would be surprising to have it automatically add an extra level of nesting that we
      #   didn't explicitly include in the path.
      # 2. Doing so would break "diggability": we couldn't dig at the same path and get the value
      #   that we just (supposedly) burried at that path.
      # 3. We don't need to be that "safe"; to be _consistent_ with dig, we _should_ actually raise an
      #   error any time we can't actually dig/bury at any subpath within that path.
      TypeError.assert.raised? { # TypeError: no implicit conversion of Symbol into Integer
      [:a, {b: {c: 1}}].dig(:b, :c) }
      [:a, {b: {c: 1}}].dig(1, :b, :c).assert == 1
      TypeError.assert.raised? { # TypeError: Symbol does not have #dig method
      [:a, {b: {c: 1}}].dig(0, :b, :c) }
    end
  end
end

test_case Hash do
  # See also: more tests that cover this in test/core/enumerable/test_set_at_path.rb
  method :bury do

    # Based on examples at https://lodash.com/docs/4.17.15#set
    test do
      a = {}
      a.set_at_path(['x', 0, 'y', 'z'], 5)
      a.bury('x', 0, 'y', 'z', 5)
      a.assert == {'x' => [{"y" => {"z" => 5}}]}
    end
    test do
      [
        {},
        { 'a': [{ 'b': { 'c': 3 } }] },
      ].each do |a|
        a.set_at_path('a.0.b.c', 4)
        a.bury(:a, 0, :b, :c, 4)
        a.assert == { a: [{ b: { c: 4 } }] }
      end
    end

    # Based on Brian Kung's examples at https://bugs.ruby-lang.org/attachments/7158 (but with
    # different results)
    test do
      {}.bury(:users, 0, :name, 'Matz').assert !=  {:users => {0 => {:name => "Matz"}}}
      {}.bury(:users, 0, :name, 'Matz').assert ==  {:users => [     {:name => "Matz"}]}
      {}.bury(:users, 1, :name, 'Matz').assert ==  {:users => [nil, {:name => "Matz"}]}
      TypeError.assert.raised? {
      [].bury(:users, 0, :name, 'Matz') }
      [{:users=>[{:name=>"Matthew"}]}].bury(0, :users, 0, :name, 'Matz').assert == [{:users=>[{:name=>"Matz"}]}]
      [{:users=>[{:name=>"Matthew"}]}].bury(1, :users, 0, :name, 'Matz').assert == [{:users=>[{:name=>"Matthew"}]}, {:users=>[{:name=>"Matz"}]}]

      {}.bury(0,   1,   2,   :foo).assert != {0 => {1 => {2 => :foo}}}
      {}.bury(0.0, 1.0, 2.0, :foo).assert == {0.0 => {1.0 => {2.0 => :foo}}}
      # TODO: What if you really want to bury/set integer keys in a hash instead? Could there be a
      # way to explicitly enable this behavior (or make it the default and make the "auto" array-behavior
      # on hashes be an opt-in option)? Maybe with a block, { Hash.new }, like in
      # https://bugs.ruby-lang.org/attachments/7158 ?
      #
      {}.bury(0,   1,   2,   :foo).assert == {0=>[nil, [nil, nil, :foo]]}
      [].bury(0,   1,   2,   :foo).assert ==    [[nil, [nil, nil, :foo]]]
    end

    test do
      assert_diggable o={}, [:users, 0, :name]
     #assert_diggable o=[], [:users, 0, :name]
      assert_diggable o={}, [:users, 1, :name]
      assert_diggable o={}, [0, :bear]
      assert_diggable o=[], [0, :bear]
      assert_diggable o={}, [:bear, 0, :frog]
    end

    test 'sequence' do
      a = {}
      {
        [:a, 0]=>"b",
        [:a, 1, :c]=>"c",
        [:a, 1, :d]=>"d"
      }.each do |path, v|
        #print "#{a.inspect}.bury(#{[*path, v].inspect}  "
        a.bury(*path, v)
        #puts "#=> #{a.inspect}"
      end
      e = {:a=>["b", {:c=>"c", :d=>"d"}]}
      a.assert == e
    end
  end
end

