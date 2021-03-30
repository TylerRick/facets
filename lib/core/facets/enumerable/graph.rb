module Enumerable

  # Like `#map`/`#collect`, but generates a Hash. The block is expected
  # to return two values: the key and the value for the new hash.
  #
  #   numbers  = (1..3)
  #   squares  = numbers.graph{ |n| [n, n*n] }   # { 1=>1, 2=>4, 3=>9 }
  #   sq_roots = numbers.graph{ |n| [n*n, n] }   # { 1=>1, 4=>2, 9=>3 }
  #
  # If block returns a hash, it will be merged into the new/result/accumulator hash.
  #
  # CREDIT: Andrew Dudzik (adudzik), Trans

  def graph(&yld)
    if yld
      h = {}
      each do |*kv|
        r = yld[*kv]
        case r
        when Hash
          h.merge!(r)
        when Range
          nk, nv = r.first, r.last
          h[nk] = nv
        else
          nk, nv = *r
          h[nk] = nv
        end
      end
      h
    else
      Enumerator.new(self,:graph)
    end
  end

end

