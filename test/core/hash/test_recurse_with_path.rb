covers 'facets/hash/recurse_with_path'
covers 'facets/hash/recurse'
#require 'byebug'

test_case Hash do
  method :recurse_with_path do
    test do
      h = {a: 'a', b: {b1: 'b1', b2: 'b2'}}
      g = h.recurse_with_path { |h, path|
        h.each_with_object({}) { |(k,v), h|
          h[k.to_s] = v
        }
      }
      g.assert == {"a"=>"a", "b"=>{"b1"=>"b1", "b2"=>"b2"}}
    end

    test do
      h = {a: 'a', b: {b1: 'b1', b2: 'b2'}}
      g = h.recurse_with_path { |h, path|
        next h if path.length < 1
        h.each_with_object({}) { |(k,v), h|
          h[k.to_s] = v
        }
      }
      g.assert == {a: 'a', b: {"b1"=>"b1", "b2"=>"b2"}}
    end

    test do
      already_added     = {options: {unwanted: 'something', other: 'other'}}
      new_and_deletions = {options: {unwanted: nil,         other: 'other', new: 'new'}, top: 'top'}
      #new = already_added.deep_merge(new_and_deletions).recurse(&:compact)
      #new.assert == {options: {                   other: 'other', new: 'new'}, top: 'top'}
      # Build a new hash that doesn't contain any keys from already_added except ones that have nil
      # value in the new_and_deletions hash.
      # Build a new hash that only contains *new* keys that weren't in already_added, or keys that
      # have a nil value in the new_and_deletions hash.
      new = new_and_deletions.recurse_with_path { |h, path|
        other_h = path.empty? ? already_added : already_added.dig(*path)
        h.each_with_object({}) { |(k,v), h|
          other_v = other_h&.[](k)
          #puts %(#{(path + [k]).inspect}: v=#{v.inspect}, key exists in other_h? #{other_h&.key?(k)}, other_v: #{other_v.inspect})
          # If the value in the new hash is a hash or nil, or the key doesn't exist in the other
          # hash, then keep the key in the new hash.
          if v.is_a?(Hash) || v.nil? || !other_h&.key?(k)
            h[k] = v
          end
        }
      }
      new.assert ==                    {options: {unwanted: nil, new: 'new'}, top: 'top'}
      new.recurse(&:compact).assert == {options: {               new: 'new'}, top: 'top'}
    end

    test "with Arrays" do
      require 'facets/array/recurse_with_path'
      objects = []
      h = {
        a: 'a',
        b: [4, 5, {c: 6}]
      }
      h.recurse_with_path(Array, Hash) {|o| objects << o; o }

      objects.assert.include? c: 6
      objects.assert.include? [4, 5, {c: 6}]
      objects.assert.include? h
      objects.length.assert == 3
    end

    test "with Arrays" do
      require 'facets/array/recurse_with_path'
      h         = {a: 'a', b: [0, 1, {b2: 'b2'}]}
      h.dig(:b, 2, :b2).assert == 'b2'
      paths = []
      g = h.recurse_with_path(Array, Hash) { |o, path|
        paths << path
        o
      }
      g.assert == {a: 'a', b: [0, 1, {b2: 'b2'}]}
      paths.assert == [ [:b, 2], [:b], [] ]
    end

    test "with Arrays (contrived, unimpressive example)" do
      require 'facets/array/recurse_with_path'
      h = {a: 'a', b: [0, 1, {b2: 'b2'}]}
      h.dig(:b, 2, :b2).assert == 'b2'
      g = h.recurse_with_path(Array, Hash) { |o, path|
        next h if path.length < 1
        h.inject({}) { |h,(k,v)|
          h[k.to_s] = v; h
        }
      }
      g.assert == {a: 'a', b: [0, 1, {b2: "b2"}]}
    end

#    test "with Arrays (how I wish it would work, but doesn't)" do
#      require 'facets/array/recurse_with_path'
#      h = {:a=>{:a1=>1, :b2=>2}, :b=>["b1", "b2"]}
#      h = {:b=>["b1", "b2"]}
#      h = {:a=>{:a1=>1, :b2=>2}, :b=>["b1", {:b2a=>"a"}]}
#
#      $d=1
#      flat = h.recurse_with_path(Array, Hash) {|h, path| h.inject({}) { |h, (k,v)| h[path + [k]] = v; h} }
#      flat.assert = {"a.a1"=>1, "a.b2"=>2, "b.0"=>"b1", "b.1"=>"b2"}
#      # {[:a]=>{[:a, :a1]=>1, [:a, :b2]=>2}, [:b]=>{[:b, "b1"]=>nil, [:b, {[:b, 1, :b2a]=>"a"}]=>nil}}
#    end

    test "with Arrays" do
      require 'facets/array/recurse_with_path'
      h = {a: 'a', b: [0, 1, {b2: 'b2'}]}
      h.dig(:b, 2, :b2).assert == 'b2'
      g = h.recurse_with_path(Array, Hash) { |o, path|
        next h if path.length < 1
        h.inject({}) { |h,(k,v)|
          h[k.to_s] = v; h
        }
      }
      g.assert == {a: 'a', b: [0, 1, {b2: "b2"}]}
    end
  end

  method :recurse_with_path! do
    test do
      h = {a: 'a', b: {b1: 'b1', b2: 'b2'}}
      h.recurse_with_path! { |h, path|
        next h if path.length < 1
        h.inject({}) { |h,(k,v)|
          h[k.to_s] = v; h
        }
      }
      h.assert == {:a=>"a", :b=>{"b1"=>"b1", "b2"=>"b2"}}
    end

  end
end
