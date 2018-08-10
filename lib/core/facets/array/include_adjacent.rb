require 'facets/array/index_all'

class Array
  # Returns true if the passed-in objects are adjacent elements in self — that is, the array
  # includes them *and* they are adjacent to each other in the array.
  #
  # [1, 2, 3].include_adjacent?(2, 3)  # => true
  # [1, 2, 3].include_adjacent?(1, 3)  # => false
  #
  # @author Tyler Rick
  #
  def include_adjacent?(*objects)
    index_all(objects[0]).any? { |start_i|
      self[start_i, objects.size] == objects
    }
  end

end

