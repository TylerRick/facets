# Based on: https://github.com/dam13n/ruby-bury/blob/master/array.rb

require 'facets/hash/bury'

class Array

  def bury *args
    if args.count < 2
      raise ArgumentError.new("2 or more arguments required")
    elsif args.count == 2
      key, value = args
      # Note: Can't use non-Integer as index into an array; this will raise TypeError if you try
      self[key] = value
      # Old version: if not integer:
      # self << { key => value }
    else
      key = index = args.shift
      # TODO?: Use this check instead of simply checking unless self[arg] because self[arg] would also be
      # false if index exists but value at that index is nil or false.
      # Analogous to unless self.key?(key) in Hash#bury.
      # unless self.length-1 >= key
      unless self[key]
        if args[0].is_a?(Integer)
          self[key] = []
        else
          self[key] = {}
        end
      end
      self[key].bury(*args)
    end
    self
  end

end
