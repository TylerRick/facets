module Enumerable
  # Returns an array with every element that matches pattern (using ===, similar to Enumerable#grep)
  # replaced with the second argument (similar to String#gsub).
  #
  # If the pattern is a Regexp:
  #
  #   el.match(pattern) is used to check for matches.
  #
  #   In the block form, the current match string is passed in as the 1st parameter, and the full
  #   MatchData object is passed in as the 2nd parameter (allowing access to capture groups—m[1] in
  #   the example below). The result from the block is used as the replacement value.
  #
  # Otherwise:
  #
  #   `pattern === el` is used to check for matches.
  #
  #   In the block form, the current matched element is passed in as the 1st parameter and the
  #   result from the block is used as the replacement value.
  #
  # Examples:
  #
  #   [1, 3, 4].gsub(3, [2, 3])                               #=> [1, [2, 3], 4]
  #   [1, 3, 3, 4].gsub(3) {|i| i+1 }                         #=> [1, 4, 4, 4]
  #   (1..4).gsub(2..3, '*')                                  #=> [1, '*', '*', 4]
  #   'hello'.chars.gsub(/[aeiou]/, '*')                      #=> ['h', '*', 'l', 'l', '*']
  #   'hello'.chars.gsub(/([aeiou])/) { |_, m| "<#{m[1]}>" }  #=> ['h', '<e>', 'l', 'l', '<o>']
  #   'hello'.chars.gsub(/./) {|s| s.ord }                    #=> [104, 101, 108, 108, 111]
  #
  # @author Tyler Rick
  #
  def gsub(pattern, replacement = nil, &block)
    dup.to_a.gsub!(pattern, replacement, &block)
  end

  def sub(pattern, replacement = nil, &block)
    dup.to_a.sub!(pattern, replacement, &block)
  end
end

class Array
  def gsub!(pattern, replacement = nil)
    case pattern
    when Regexp
      replace(map { |el|
        if (match_data = el.match(pattern))
          if block_given?
            yield match_data[0], match_data
          else
            replacement
          end
        else
          el
        end
      })
    else
      replace(map { |el|
        if pattern === el
          if block_given?
            yield el
          else
            replacement
          end
        else
          el
        end
      })
    end
  end

  def sub!(pattern, replacement = nil)
    matched_yet = false
    case pattern
    when Regexp
      replace(map { |el|
        if !matched_yet and (match_data = el.match(pattern))
          matched_yet = true
          if block_given?
            yield match_data[0], match_data
          else
            replacement
          end
        else
          el
        end
      })
    else
      replace(map { |el|
        if !matched_yet and pattern === el
          matched_yet = true
          if block_given?
            yield el
          else
            replacement
          end
        else
          el
        end
      })
    end
  end
end
