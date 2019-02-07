class Array

  # Apply a block to array, and recursively apply that block
  # to each sub-array or +types+.
  #
  #   arr = ["a", ["b", "c", nil], nil]
  #   arr.recurse_with_path{ |a| a.compact! }
  #   #=> ["a", ["b", "c"]]
  #
  def recurse_with_path(*types, path: [], &block)
    types = [self.class] if types.empty?
    a = each.with_index.inject([]) do |array, (value, i)|
      case value
      when *types
        array << value.recurse_with_path(*types, path: path + [i], &block)
      else
        array << value
      end
      array
    end
    yield a, path
  end

  # In-place form of #recurse_with_path.
  #def recurse_with_path!(*types, path: [], &block)
  def recurse_with_path!(&block)
    replace(recurse_with_path(&block))
  end

end
