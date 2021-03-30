# Based on: https://github.com/dam13n/ruby-bury/blob/master/array.rb

require 'facets/hash/bury'

class Array

  def bury *args
    if args.count < 2
      raise ArgumentError.new("2 or more arguments required")
    elsif args.count == 2
      if args[0].is_a? Integer
        self[args[0]] = args[1]
      else
        self << { args[0] => args[1] }
      end
    else
      if args[0].is_a? Integer
        arg = args.shift
        unless self.length-1 >= arg # self.key?(arg)
          if args[0].is_a?(Integer)
            self[arg] = []
          else
            self[arg] = {}
          end
        end
        self[arg].bury(*args)
      else
        self << Hash.new.bury(*args)
      end
    end
    self
  end

end
