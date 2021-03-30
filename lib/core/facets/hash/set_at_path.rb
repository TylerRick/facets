require 'facets/hash/bury'
require 'facets/dot_path'

class Hash
  # Works like https://lodash.com/docs/4.17.15#set
  def set_at_path(path, value)
    bury(*path, value)
  end

  # Works like https://lodash.com/docs/4.17.15#set
  # {}.set_at_dot_path('a.0.b.c', 4)
  def set_at_dot_path(path, value, transform_key: :symbolize)
    path = DotPath.from_dot_path_to_array(path, transform_key: transform_key)
    bury(*path, value)
  end
end

