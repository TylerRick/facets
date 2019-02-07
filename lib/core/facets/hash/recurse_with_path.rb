class Hash

  # Apply a block to hash, and recursively apply that block
  # to each sub-hash or +types+.
  #
  #   h = {:a=>1, :b=>{:b1=>1, :b2=>2}}
  #   g = h.recurse_with_path{|h| h.inject({}){|h,(k,v)| h[k.to_s] = v; h} }
  #   g  #=> {"a"=>1, "b"=>{"b1"=>1, "b2"=>2}}
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
