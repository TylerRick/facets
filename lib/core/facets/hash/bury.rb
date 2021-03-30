# Based on: https://github.com/dam13n/ruby-bury/blob/master/hash.rb

require 'facets/array/bury'

class Hash

  def bury *args
    if args.count < 2
      raise ArgumentError.new("2 or more arguments required")
    elsif args.count == 2
      self[args[0]] = args[1]
    else
      arg = args.shift
      unless self.key?(arg)
        # Difference from dam13n's version:
        # if pre-shift args was [:a, 0, ...], then initialize self[:a] as an array to allow next
        # key/index to be treated as an index into the array rather than a key in a hash.
        # This makes it work more like https://rubydoc.info/gems/xkeys/XKeys%2FSet_Auto:[]=
        if args[0].is_a?(Integer)
          self[arg] = []
        else
          self[arg] = {}
        end
      end
      self[arg].bury(*args) unless args.empty?
    end
    self
  end

end
