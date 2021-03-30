covers 'facets/hash/recurse'

test_case Hash do

  method :recurse do

    test do
      h = {:a=>1, :b=>{:b1=>1, :b2=>2}}
      g = h.recurse { |h|
        h.each_with_object({}) { |(k,v), h|
          h[k.to_s] = v
        }
      }
      g.assert == {"a"=>1, "b"=>{"b1"=>1, "b2"=>2}}
    end

    test "with Arrays" do
      require 'facets/array/recurse'
      objects = []
      h = {
        a: 'a',
        b: [4, 5, {c: 6}]
      }
      h.recurse(Array, Hash) {|o| objects << o; o }

      objects.assert.include? c: 6
      objects.assert.include? [4, 5, {c: 6}]
      objects.assert.include? h
      objects.length.assert == 3
    end

  end

  method :recurse! do

    test do
      h = {:a=>1, :b=>{:b1=>1, :b2=>2}}
      h.recurse!{|h| h.inject({}){|h,(k,v)| h[k.to_s] = v; h} }
      h.assert == {"a"=>1, "b"=>{"b1"=>1, "b2"=>2}}
    end

  end

end

