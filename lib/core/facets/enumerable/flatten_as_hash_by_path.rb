require 'facets/enumerable/graph'
require 'facets/enumerable/recursively'
require 'facets/hash/recursively'  # don't use Enumerable#recursively for Hash
require 'facets/nested_object_path'

module Enumerable
  # Recursively flatten a nested hash/array structure, returning a flat (non-nested) hash where the
  # key is the full array "path" (which can be used with dig, for example) to the original key/value.
  #
  # Like the name suggests, this always returns a hash, even if the receiver (the top-level object
  # containing the nested hash/arrays tructure) was an array. This is in contrast with Hash#flatten,
  # which always returns an array and which is not recursive (at all, by default; and when
  # explicitly enabled, only for arrays within the hash).
  #
  # @example
  #
  #   i = {a: ['b', {c: 'c', d: 'd'}]}
  #   i.flatten_as_hash_by_path
  #   #=> {[:a, 0]=>"b", [:a, 1, :c]=>"c", [:a, 1, :d]=>"d"}
  #
  def flatten_as_hash_by_path(
    transform_path: ->(path) {path},
    path: [],
    &block
  )
    self.recursively(Enumerable) { |k,v, path, this|
      # Even though the default recursive block is just this for Arrays, it defaults to the 2nd block
      # for Hash, which wouldn't work.
      #puts "at #{'%-20s' % path.inspect}: #{{k => v}.inspect}          this= #{this.inspect} (rec)"
      v
    }.graph { |k,v, path, this|
      #puts "at #{'%-20s' % path.inspect}: #{{k => v}.inspect}           this=#{this.inspect}"
      [transform_path.(path), v]
    }
  end

  # Like flatten_as_hash_by_path but uses a "a.2.c"-style string path format.
  def flatten_as_hash_by_dot_path(&block)
    flatten_as_hash_by_path(transform_path: NestedObjectPath.method(:to_dot_path), &block)
  end

  # Like flatten_as_hash_by_path but uses a "a[2].c"-style string path format.
  def flatten_as_hash_by_dot_bracket_path(&block)
    flatten_as_hash_by_path(transform_path: NestedObjectPath.method(:to_dot_bracket_path), &block)
  end

  # Like flatten_as_hash_by_path but uses a "a[2][c]"-style string path format.
  def flatten_as_hash_by_bracket_path(&block)
    flatten_as_hash_by_path(transform_path: NestedObjectPath.method(:to_bracket_path), &block)
  end
end
