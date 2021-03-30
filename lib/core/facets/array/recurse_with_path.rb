class Array

  # Apply a block to array, and recursively apply that block
  # to each sub-array or +types+.
  #
  # This works the same as recurse except it yields |sub_hash, path| instead of just |sub_hash|.
  #
  # @example
  #
  #   # TODO: come up with good example
  #
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
