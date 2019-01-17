require_relative 'first_while'

module Enumerable
  def last_while(n = nil, &block)
    reverse_each.first_while(n, &block)
      .reverse_each
  end

  # Core Ruby provides Enumerable#reverse_each, Enumerable#first, and Array#last but not Enumerable#last.
  def last(n = nil)
    if n
      reverse_each.first(n).reverse_each
    else
      reverse_each.first
    end
  end
end

class Enumerator::Lazy
  # TODO
end
