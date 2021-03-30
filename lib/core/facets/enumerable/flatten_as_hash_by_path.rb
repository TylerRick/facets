require 'facets/enumerable/graph'
require 'facets/enumerable/recursively'
require 'facets/hash/recursively'  # don't use Enumerable#recursively for Hash
require 'facets/dot_path'

module Enumerable
  # Recursively flatten a hash/array, changing from nested hashes/arrays to a flat hash where the
  # key is a the full "path" (which can be used with dig, for example) of the original key in
  # "a.b.c" format.
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

  def flatten_as_hash_by_dot_path(&block)
    flatten_as_hash_by_path(transform_path: DotPath.method(:from_array_to_dot_path), &block)
  end
end
