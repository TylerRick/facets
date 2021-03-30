require 'facets/string/to_integer'
require 'facets/kernel/respond_or_self'

module DotPath
  def self.from_array_to_dot_path(path)
    path.join('.')
  end

  # Splits a dot path into "keys" (components of the path). Then performs standard transform on each
  # key:
  # - convert to integer if we can
  # - otherwise call transform_key.(el)
  # Optionally pass custom transform_key option if you want to further transform the key after
  # standard transform.
  def self.from_dot_path_to_array(path, transform_key: ->(k) {k})
    if transform_key == :symbolize
      transform_key = ->(k) {
        k.respond_or_self.to_sym
      }
    end
    path.split('.').map { |k|
      k.to_integer ||
      transform_key.(k)
    }
  end
end
