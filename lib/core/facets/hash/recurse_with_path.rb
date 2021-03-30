class Hash

  # Apply a block to hash, and recursively apply that block
  # to each sub-hash or +types+.
  #
  # This works the same as recurse except it yields |sub_hash, path| instead of just |sub_hash|.
  #
  # @example
  #
  #   # To recursively transform_keys such that the key represents the full path that would be used
  #   to access this value in the original hash (using dig):
  #
  #   h = {:a=>1, :b=>{:b1=>1, :b2=>2}}
  #   h.recurse_with_path{|h, path| h.inject({}) { |h, (k,v)| h[path + [k]] = v; h} }
  #   # => {[:a]=>1, [:b]=>{[:b, :b1]=>1, [:b, :b2]=>2}}
  #
  # @example
  #
  #   # To recursively flatten a hash, changing from nested hashes to a flat hash where the key is a
  #   the full path of the original key in "a.b.c" format:
  #
  #   flat = h.recurse_with_path { |sub_hash, path|
  #     flat = {}
  #     sub_hash.each { |k,v|
  #       if v.is_a?(Hash)
  #         flat.merge!(v)
  #       else
  #         flat[(path + [k]).join('.')] = v
  #       end
  #     }
  #     flat
  #   }
  #   => {"a"=>1, "b.b1"=>1, "b.b2"=>2}
  #
  #  @author Trans         (recurse)
  #  @author Tyler Rick    (recurse_with_path)
  #
  def recurse_with_path(*types, path: [], &block)
    path ||= []
    types = [self.class] if types.empty?
    #puts %(self=#{(self).inspect})
    h = inject({}) do |hash, (key, value)|
      case value
      when *types
        #puts %(#{hash}[#{key.inspect}]=#{value.inspect})
        #byebug if value.is_a? Array
        hash[key] = value.recurse_with_path(*types, path: path + [key], &block)
      else
        hash[key] = value
      end
      hash
    end
    yield h, path
  end

  # In-place form of #recurse_with_path.
  def recurse_with_path!(*types, path: [], &block)
    types = [self.class] if types.empty?
    replace(recurse_with_path(*types, path, &block))
  end

end
