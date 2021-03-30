require 'facets/enumerable/bury'
require 'facets/nested_object_path'

#class Hash
module Enumerable
  # Just like bury except that it takes two distinct args, path and value, instead of mixing path
  # and value in the same args array.
  #
  # Works very similarly like https://lodash.com/docs/4.17.15#set
  #
  # {}.set_at_path([:a, 0, :b], 4)      #=>  { a: [ { b: 4 } ] }
  # {}.set_at_string_path('a.0.b', 4)     #=>  { a: [ { b: 4 } ] }
  # [].set_at_path([:a, 0, :b], 4)      #=> [{ a: [ { b: 4 } ] }]
  #
  def set_at_path(path, value, **opts)
    path = NestedObjectPath.to_path(path, **opts)
    bury(*path, value)
  end
end

