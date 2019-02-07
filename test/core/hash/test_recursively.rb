covers 'facets/hash/recursively'
covers 'facets/hash/graph'
require 'byebug'

test_case Hash do

  method :recursively do
    test "each (arity 2)" do
      h = {a: 1, b: {c: 3}}
      r = []
      h.recursively.each{ |k,v|
        r << [k,v]
      }
      r.assert.include? [:a, 1]
      r.assert.include? [:b, {c: 3}]
      r.assert.include? [:c, 3]
    end

    test "each (arity 3)" do
      h = {a: 1, b: {c: 3}}
      r = []
      paths = []
      h.recursively.each{ |k,v,path|
        paths << path
        r << [k,v]
      }
      r.assert.include? [:a, 1]
      r.assert.include? [:b, {c: 3}]
      r.assert.include? [:c, 3]
      paths.assert == [[:a], [:b, :c], [:b]]
    end

    test "map" do
      h = {a: 1, b: {c: 3}}
      r = h.recursively { |k,v|
        [k,v]
      }.map { |k,v|
        [k, v.succ]
      }
      r.assert.include? [:a,2]
      r.assert.include? [:b,[[:c,4]]]
    end

    test "map (moot)" do
      h = {a: 1, b: {c: 3}}
      a = h.recursively.map { |k,v|
        [k, v]
      }
      a.assert.include? [:a,1]
      a.assert.include? [:b,[[:c,3]]]
    end

    test "map (arity 3)" do
      h = {
        a: {'a.a': 'a.a'},
        b: {'b.a': 'b.a'}
      }
      a = h.recursively.map { |k,v,path|
        depth = path.size
        [k, v, depth]
      }
      a.assert ==  [
        [:a, [[:"a.a", "a.a", 2]], 1],
        [:b, [[:"b.a", "b.a", 2]], 1]
      ]
    end

    test 'graph' do
      h = {a: 1, b: {c: 3}}
      r = h.recursively { |k,v|
        [k.to_s, v]
      }.graph { |k,v|
        [k.to_s, v.to_s]
      }
      r.assert == {'a'=>'1','b'=>{'c'=>'3'}}
    end

    test 'graph!' do
      h = {a: 1, b: {c: 3}}
      h.recursively { |k,v|
        [k.to_s, v]
      }.graph! { |k,v|
        [k.to_s, v.to_s]
      }
      h.assert == {'a'=>'1','b'=>{'c'=>'3'}}
    end

    test 'mash (arity 2)' do
      h = {a: 1, b: {c: 3}}
      r = h.recursively { |k,v|
        [k.to_s, v]
      }.mash { |k,v|
        [k.to_s, v.to_s]
      }
      r.assert == {'a'=>'1','b'=>{'c'=>'3'}}
    end

    test 'mash (arity 3)' do
      h = {a: 1, b: {c: 3}}
      r = h.recursively { |k,v, path|
        [k.to_s, v]
      }.mash { |k,v, path|
        [k.to_s, v.to_s]
      }
      r.assert == {'a'=>'1','b'=>{'c'=>'3'}}
    end

    test do
      require 'facets/hash/recurse'
      already_added     = {options: {unwanted: 'something', other: 'other'}}
      new_and_deletions = {options: {unwanted: nil,         other: 'other', new: 'new'}, top: 'top'}
      # Build a new hash that only contains *new* keys that weren't in already_added, or keys that
      # have a nil value in the new_and_deletions hash.
      new = new_and_deletions.recursively { |k, v, path|
        [k, v]
      }.mash { |k,v, path|
        #puts %(=> path=#{path}, k=#{k.inspect}, v=#{v.inspect})
        other_v = already_added.dig(*path)
        #puts %(#{path.inspect}: v=#{v.inspect}, key exists in other_h? #{other_h&.key?(k)}, other_v: #{other_v.inspect})
        # If the value in the new hash is a hash or nil, or the key doesn't exist in the other
        # hash, then keep the key in the new hash.
        if v.is_a?(Hash) || v.nil? || other_v.nil? # !other_h&.key?(k)
          [k, v]
        #else
        #  throw :skip
        end
      }
      new.assert ==                    {options: {unwanted: nil, nil=>nil, new: 'new'}, top: 'top'}
      new.recurse(&:compact).assert == {options: {                         new: 'new'}, top: 'top'}
    end
  end

  method :recursively_comparing do
    test do
      require 'facets/hash/recurse'
      already_added     = {options: {unwanted: 'something', other: 'other'}}
      new_and_deletions = {options: {unwanted: nil,         other: 'other', new: 'new'}, top: 'top'}
      # Build a new hash that only contains *new* keys that weren't in already_added, or keys that
      # have a nil value in the new_and_deletions hash.
      new = new_and_deletions.recursively_comparing(already_added) { |k, v, other|
        [k, v]
      }.mash { |k,v, other|
        if v.is_a?(Hash) || v.nil? || other.nil?
          [k, v]
        end
      }
      new.assert ==                    {options: {unwanted: nil, nil=>nil, new: 'new'}, top: 'top'}
      new.recurse(&:compact).assert == {options: {                         new: 'new'}, top: 'top'}

      new = new_and_deletions.recursively_comparing(already_added).mash { |k,v, other|
        if v.is_a?(Hash) || v.nil? || other.nil?
          [k, v]
        end
      }
      new.assert ==                    {options: {unwanted: nil, nil=>nil, new: 'new'}, top: 'top'}
      new.recurse(&:compact).assert == {options: {                         new: 'new'}, top: 'top'}
    end
  end

  method :recursively do
    test 'mash!' do
      h = {a: 1, b: {c: 3}}
      h.recursively { |k,v|
        [k.to_s, v]
      }.mash! { |k,v|
        [k.to_s, v.to_s]
      }
      h.assert == {'a'=>'1','b'=>{'c'=>'3'}}
    end

if true
    #test 'merge' do
    #  h1 = {:a=>1,:b=>{:c=>3}}
    #  h2 = {:b=>{:d=>4}}
    #  r = h1.recursively.merge(h2)
    #  r.assert == {:a=>1,:b=>{:c=>3, :d=>4}}
    #end

    #test 'merge!' do
    #  h1 = {:a=>1,:b=>{:c=>3}}
    #  h2 = {:b=>{:d=>4}}
    # h1.recursively.merge!(h2)
    #  h1.assert == {:a=>1,:b=>{:c=>3, :d=>4}}
    #end
end

  end
end
