require 'facets/functor'
require 'facets/enumerable/recursively'

class Hash

  # Apply a block to a hash, and recursively apply that block
  # to each sub-hash:
  #
  #     h = {:a=>1, :b=>{:x=>1, :y=>2}}
  #     h.recursively.map{ |k,v| [k.to_s, v] }
  #     #=> [["a", 1], ["b", [["y", 2], ["x", 1]]]]
  #
  # The recursive iteration can be treated separately from the non-recursive
  # iteration by passing a block to the #recursive method:
  #
  #     h = {:a=>1, :b=>{:x=>1, :y=>2}}
  #     h.recursively{ |k,v| [k.to_s, v] }.map{ |k,v| [k.to_s, v.to_s] }
  #     #=> [["a", "1"], ["b", [["y", "2"], ["x", "1"]]]]
  #
  def recursively(*types, path: [], &block)
    Recursor.new(self, *types, path: path, &block)
  end

  class Recursor < Enumerable::Recursor #:nodoc:
    def initialize(enum, *types, path: [], &block)
      @path = path
      super(enum, *types, &block)
    end
    def method_missing(op, &yld)
      yld = yld    || lambda{ |k,v| [k,v] }  # ? to_enum
      rec = @block || yld #lambda{ |k,v| [k,v] }
      @enum.__send__(op) do |k,v|
        path = @path + [k]
        #puts %(#{@enum.inspect}: path=#{path}, k=#{k.inspect}, v=#{v.inspect})
        case v
        when String # b/c of 1.8
          if yld.arity == 3 or yld.arity == -1
            yld.call(k, v, path)
          else
            yld.call(k, v)
          end
        when *@types
          res = v.recursively(*@types, path: path, &@block).__send__(op,&yld)
          if rec.arity == 3 or rec.arity == -1
            rec.call(k, res, path)
          else
            rec.call(k, res)
          end
        else
          if yld.arity == 3 or yld.arity == -1
            yld.call(k, v, path)
          else
            yld.call(k, v)
          end
        end
      end
    end
  end

  def recursively_comparing(other_enum, path: [], &block)
    ComparingRecursor.new(self, other_enum, &block)
  end

  class ComparingRecursor < Enumerable::Recursor #:nodoc:
    def initialize(enum, other_enum, *types, &block)
      @other_enum = other_enum
      super(enum, *types, &block)
    end
    def method_missing(op, &yld)
      yld = yld    || lambda{ |k,v| [k,v] }  # ? to_enum
      rec = @block || yld #lambda{ |k,v| [k,v] }
      @enum.__send__(op) do |k,v|
        other_v = @other_enum.dig(k)
        #puts %(#{@enum.inspect}: k=#{k.inspect}, v=#{v.inspect}, other_v=#{other_v.inspect})
        case v
        when String # b/c of 1.8
          yld.call(k, v, other_v)
        when *@types
          res = v.recursively_comparing(other_v, &@block).__send__(op,&yld)
          rec.call(k, res, other_v)
        else
          yld.call(k, v, other_v)
        end
      end
    end
  end

## TODO: When no longer need 1.8.6 support.
=begin
  def recursively(*types, &block)
    types = types.empty? ? [self.class] : types
    Functor.new do |op, &yld|
      rec = block || yld
      __send__(op) do |k,v|
        case v
        when *types
          rec.call(k, v.recursively(*types, &block).__send__(op,&yld))
        else
          yld.call(k,v)
        end
      end
    end
  end
=end

end

