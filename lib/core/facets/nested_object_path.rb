require 'facets/string/to_integer'
require 'facets/kernel/respond_or_self'

require 'facets/enumerable/bury'

# A path identifies a location in a nested hash/array data structure and can be used to get (dig) or
# set (bury) values from that nested structure.
#
# It is also used by Enumerable#flatten_as_hash_by_path and Hash#unflatten_by_path.
#
# A path can be represented in various forms:
# - Its canonical form ("path") is an array of keys (each of which can be string, symbol, integer, etc.).
# - A more compact format is a string ("string_path") where the keys are delimited by dots (.)
#   and/or brackets ([]).
#   - "dot_path" is the simplest and only uses dots
#   - "dot_bracket_path" uses [] for integer keys (indexes) and dots for all others
#   - "bracket_path" uses [] for all keys except the first
#
# This module includes conversions between those forms.
#
# TODO: Come up with a better API for this
#
# Discuss: Should flatten_as_hash_by_path, unflatten_by_path, set_at_dot_path all be included in
# this same file (organized by topic instead of by core class/module)? Should this (along with bury)
# be its own separate gem? If it were a separate gem, then we couldn't use any of its methods from
# other Facets methods (without making it a deendency).
#
module NestedObjectPath
  def self.to_dot_path(path)
    path.join('.')
  end
  def self.to_dot_bracket_path(path)
    path.to_enum(:inject, '').with_index do |(out, k), i|
      if i == 0
        out << k.to_s
      elsif k.is_a?(Integer)
        out << "[#{k}]"
      else
        out << ".#{k}"
      end
      out
    end
  end
  def self.to_bracket_path(path)
    path.to_enum(:inject, '').with_index do |(out, k), i|
      if i == 0
        out << k.to_s
      else
        out << "[#{k}]"
      end
      out
    end
  end

  # Based on final-form/src/structure/toPath.js
  # @private
  def self.keys_regex
    /[.\[\]]+/
  end

  # Normalize the input path (which can be an array or a "string_path") into a canonical array "path".
  #
  # If a string_path is given: Splits it into "keys" (components of the path). '.' and '['
  # delimiters are treated the same; ']' is ignored. Then performs standard transform on each key:
  # - convert to integer if we can
  # - otherwise the key will be a string
  #   - transform_key.(key) (which by default converts string to symbol) will be called on the string key
  #
  # If an array path is given: Only does, for each key:
  # - if key is not Integer:
  #   - transform_key.(key) (which by default is a no-op) will be called on the string key
  #
  # If input is a string_path:
  #   By default, transform_key will call :to_sym on any string key (technically any
  #   non-Integer key that responds to to_sym) keys. Why?
  #
  #   1. Because string paths are a shorthand that we want to be convenient, and symbols are more
  #     convenient as keys: {a: 1} vs. {'a' => 1}
  #   2. Because when using a string path there is no direct way to specify that the keys in that
  #     path should actually be symbols. (Splitting a string always results in an array of strings.)
  #
  #   You can opt out of this by passing transform_key: false
  #
  # If input is an array path:
  #   transform_key is a no-op by default. Each key in the array will be left and used as-is.
  #
  #   (There is no need to have the default transform_key be :to_sym because it is easy to directly
  #   include symbol keys in the array path. This way, it is just as easy to use string keys as it
  #   is to use symbol keys.)
  #
  # Optionally pass custom transform_key option if you want to do a different transform on non-Integer keys.
  #
  def self.to_path(input, transform_key: :default)
    if input.nil? || input.empty?
      return []
    end

    if    transform_key == :default && input.is_a?(String)
      transform_key = :to_sym
    elsif transform_key == :default || !transform_key  # nil or false
      transform_key = ->(k) {k}
    end

    if transform_key.is_a? Symbol
      transform_key_sym = transform_key
      transform_key = ->(k) {
        k.respond_or_self.__send__(transform_key_sym)
      }
    end

    case input
    when Array
      input.map { |k|
        if k.is_a?(Integer)
          k
        else
          transform_key.(k)
        end
      }
    when String
      input.split(keys_regex).map { |k|
        k.to_integer ||
        transform_key.(k)
      }
    else
      raise ArgumentError, "input must be an array or string"
    end
  end
end
