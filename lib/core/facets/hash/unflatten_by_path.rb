require 'facets/enumerable/bury'
require 'facets/enumerable/flatten_as_hash_by_path'
require 'facets/dot_path'

class Hash

  # This currently assumes the top-level object is a Hash
  # TODO: make it also work with top level being array?
  # TODO: this currently relies on bury, which is only defined for Hash and Array
  def unflatten_by_path(new = {})
    each do |path, v|
      #print "#{new.inspect}.bury(#{[*path, v].inspect}  "
      new.bury(*path, v)
      #puts "#=> #{new.inspect}"
    end
    new
  end

  def unflatten_by_dot_path(*args, **opts)
    transform_keys_from_dot_path(**opts).
      unflatten_by_path(*args)
  end

  def transform_keys_from_dot_path(**opts)
    transform_keys { |path|
      DotPath.from_dot_path_to_array(path, **opts)
    }
  end

end
