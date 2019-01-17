module Enumerable
  def while(&block)
    Enumerator.new do |yielder|
      each do |el|
        break unless yield(el)
        yielder << el
      end
    end
  end

  # A cross between while and first. This accepts an optional number of elements to take from the
  # beginning of the enumerable, like first does.
  def first_while(n = nil, &block)
    if n
      self.while(&block).take(n)
    else
      self.while(&block)
    end
  end
end

class Enumerator::Lazy
  # TODO
end
