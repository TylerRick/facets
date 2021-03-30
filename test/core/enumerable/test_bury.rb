covers 'facets/hash/bury'
covers 'facets/array/bury'
covers 'facets/hash/set_at_path'

require 'facets/enumerable/bury'

test_case Array do
end

test_case Hash do
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
        a.set_at_dot_path('a.0.b.c', 4)
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
      [].bury(:users, 0, :name, 'Matz').assert == [{:users=>[{:name=>"Matz"}]}]
      [{:users=>[{:name=>"Matthew"}]}].bury(   :users, 0, :name, 'Matz').assert == [{:users=>[{:name=>"Matthew"}]}, {:users=>[{:name=>"Matz"}]}]
      [{:users=>[{:name=>"Matthew"}]}].bury(1, :users, 0, :name, 'Matz').assert == [{:users=>[{:name=>"Matthew"}]}, {:users=>[{:name=>"Matz"}]}]
      {}.bury(0.0, 1.0, 2.0, :foo).assert == {0.0 => {1.0 => {2.0 => :foo}}}
      # TODO: What if you really want to bury/set integer keys in a hash instead? Could there be a
      # way to explicitly enable this behavior (or make it the default and make the array-behavior
      # on hashes be an opt-in option)? Maybe with a block, { Hash.new }, like in
      # https://bugs.ruby-lang.org/attachments/7158 ?
      {}.bury(0,   1,   2,   :foo).assert != {0 => {1 => {2 => :foo}}}
      {}.bury(0,   1,   2,   :foo).assert == {0=>[nil, [nil, nil, :foo]]}
      [].bury(0,   1,   2,   :foo).assert ==    [[nil, [nil, nil, :foo]]]
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

