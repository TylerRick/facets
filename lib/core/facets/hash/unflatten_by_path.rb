require 'facets/enumerable/bury'
require 'facets/enumerable/flatten_as_hash_by_path'
require 'facets/nested_object_path'

class Hash

  # Reverses flatten_as_hash_by_path, creating a nested hash/array structure by setting each value
  # in the new hash using each key as the "path" at which to set it (using `bury`).
  #
  # By default, this assumes the top-level object is a Hash. If the top-level object should be an
  # Array instead, pass [] as the first argument.
  #
  # Note: This currently relies on bury, which is only defined for Hash and Array. So if you flatten
  # a nested structure that contained nested objects _other_ than Hash or Array, this won't be able to
  # reverse that operation.
  #
  def unflatten_by_path(new = {})
    each do |path, v|
      #print "#{new.inspect}.bury(#{[*path, v].inspect}  "
      new.bury(*path, v)
      #puts "#=> #{new.inspect}"
    end
    new
  end

  # Reverses flatten_as_hash_by_path when keys were converted to string paths
  # (flatten_as_hash_by_dot_path, flatten_as_hash_by_dot_bracket_path, or
  # flatten_as_hash_by_bracket_path), creating a nested hash/array structure by setting each value
  # in the new hash using each key as the "path" at which to set it (using `bury`).
  def unflatten_by_string_path(*args, **opts)
    transform_keys_to_path(**opts).
      unflatten_by_path(*args)
  end

  def transform_keys_to_path(**opts)
    transform_keys { |path|
      NestedObjectPath.to_path(path, **opts)
    }
  end

end
