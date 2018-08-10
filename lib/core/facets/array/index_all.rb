
class Array
  # Like index/rindex but returns an array of all indexes.
  #
  # Returns the _indexes_ of all object in receiver such that the object is == to obj.
  #
  # If a block is given instead of an argument, returns the _index_ of all object for which the
  # block returns true.
  #
  # Returns [] if no match is found.
  #
  #  a = [ "a", "b", "c" ]
  #  a.index_all("b")              #=> [1]
  #  a.index_all("z")              #=> []
  #  a.index_all { |x| x == "b" }  #=> [1]
  #
  # See also: proposal to add Array#indexes to Ruby language: https://bugs.ruby-lang.org/issues/6596
  #
  def index_all(other = nil)
    if other
      each_index.select {|i| self[i] == other }
    else
      each_index.select {|i| yield(self[i]) }
    end
  end

end

