require 'facets/functor'

module Enumerable

  # Returns a recursive functor, that allows enumerable methods to iterate
  # through enumerable sub-elements. By default it only recurses over
  # elements of the same type.
  #
  def old_recursively(*types, &block)
    Recursor.new(self, *types, &block)
  end
  def recursively(*types, path: [], &block)
    types = types.empty? ? [self.class] : types
    Functor.new do |op, &yld|
      rec = block || lambda{ |v| v }
      yld = yld   || lambda{ |v| v }  # ? to_enum
      __send__(op).with_index do |v, k|
        local_path = path + [k]
        case v
        when *types
          res = v.recursively(*types, path: local_path, &block).__send__(op,&yld)
          if rec.arity == 3 or rec.arity == -1
            # TODO: should path be passed as KW arg path: local_path here too?
            rec.call(k, res, local_path)
          else
            rec.call(res)
          end
        else
          if yld.arity == 3 or yld.arity == -1
            yld.call(k, v, local_path)
          else
            yld.call(v)
          end
        end
      end
    end
  end

  # Recursor is a specialized Functor for recursively iterating over Enumerables.
  #
  # TODO: Return Enumerator if no +yld+ block is given.
  #
  # TODO: Add limiting +depth+ option to Enumerable#recursively?
  #
  class Recursor
    instance_methods(true).each{ |m| private m unless /^(__|object_id$)/ =~ m.to_s }

    def initialize(enum, *types, path: [], &block)
      @path = path
      @enum   = enum
      @types  = types.empty? ? [@enum.class] : types
      @block  = block
    end

    def method_missing(op, &yld)
      rec = @block || lambda{ |v| v }
      yld = yld    || lambda{ |v| v }  # ? to_enum
      @enum.__send__(op).with_index do |v, k|
        path = @path + [k]
        case v
        when String # b/c of 1.8
          if yld.arity == 3 or yld.arity == -1
            yld.call(k, v, path)
          else
            yld.call(v)
          end
        when *@types
          res = v.recursively(*@types, path: path, &@block).__send__(op,&yld)
          if rec.arity == 3 or rec.arity == -1
            rec.call(k, res, path)
          else
            rec.call(res)
          end
        else
          if yld.arity == 3 or yld.arity == -1
            yld.call(k, v, path)
          else
            yld.call(v)
          end
        end
      end
    end
  end
end

