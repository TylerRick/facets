class Array
  # An Enumerator for _all_ indexes is returned if no block is given.
  def index_all(other = nil)
    if other
      each_index.select {|i| self[i] == other }
    elsif block_given?
      each_index.select {|i| yield(self[i]) }
    else
      each_index
    end
  end
end

module Enumerable

  # Like Array#index/rindex and Enumerable#find_index but returns an array of _all_ indexes.
  #
  # Returns an enumerator of _indexes_ of all object in receiver such that the object is == to obj.
  #
  # If a block is given instead of an argument, returns the _index_ of all object for which the
  # block returns true.
  #
  # Returns [] if no match is found.
  #
  #  a = [ "a", "b", "c" ]
  #  a.index_all("b").to_a              #=> [1]
  #  a.index_all("z").to_a              #=> []
  #  a.index_all { |x| x == "b" }.to_a  #=> [1]
  #
  #
  # See also: proposal to add Array#indexes to Ruby language: https://bugs.ruby-lang.org/issues/6596
  #
  # @author Tyler Rick
  #
  # TODO: move to Indexable?
  #
  def index_all(other = nil)
    if other
      each_with_index.select {|el, i| el == other   }.map {|el, i| i }
    elsif block_given?
      each_with_index.select {|el, i| yield(el)     }.map {|el, i| i }
    else
      each_with_index.                                map {|el, i| i }.to_enum
    end
  end
  alias_method :indexes, :index_all

end

class Enumerator::Lazy
  # Like Array#index/rindex and Enumerable#find_index but returns an array of _all_ indexes.
  #
  # Returns an enumerator of _indexes_ of all object in receiver such that the object is == to obj.
  #
  # If a block is given instead of an argument, returns the _index_ of all object for which the
  # block returns true.
  #
  # Returns [] if no match is found.
  #
  #  a = [ "a", "b", "c" ]
  #  a.index_all("b").to_a              #=> [1]
  #  a.index_all("z").to_a              #=> []
  #  a.index_all { |x| x == "b" }.to_a  #=> [1]
  #
  #  (1..Float::INFINITY).lazy.index_all
  #
  # @author Tyler Rick
  #
  def index_all(other = nil)
    if other
      each_with_index.lazy.select {|el, i| el == other }.map {|el, i| i }
    elsif block_given?
      each_with_index.lazy.select {|el, i| yield(el)   }.map {|el, i| i }
    else
      each_with_index.lazy.                              map {|el, i| i }.to_enum
    end
  end

end
