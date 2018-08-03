require 'facets/enumerable/contiguous'

module Enumerable
  # Given a "discontiguous range" (an array of contiguous ranges) of a non-decreasing sequence,...
  #
  # It returns the gaps inclusively by default:
  # - each range returned represents a gap within which there is at least one missing element in the
  # strictly increasing sequence that the receiver is a subset of
  #
  #   ex.
  #   contiguous_ranges.gap_ranges
  #
  # If you instead want the range of *elements that are missing* from that strictly increasing sequence, you can pass inclusive: true
  # However, that requires the object to respond to both +succ+ and +pred+ — in other words, it
  # works for Integers, but not Strings.
  #
  #   ex.
  #
  # If receiver is not monotically increasing, the result may not be meaningful since the begin/end
  # of the Range is reversed ((3..2).to_a is []).
  #
  # [1..3, 2..4].gap_ranges
  # # => [3..2]
  #
  # @author Tyler Rick
  #
  def gap_ranges(inclusive: true, single_element_ranges: true)
    each_cons(2).map { |a, b|
      a = a.end   if a.respond_to? :end
      b = b.begin if b.respond_to? :begin
      range = \
        if inclusive
          a .. b
        else
          a.succ .. b.pred
        end
      if !single_element_ranges && range.size == 1
        range.begin
      else
        range
      end
    }
  end

  # Like #gap_ranges(inclusive: false) but returns the *elements* that are missing from a
  # monotically increasing sequence of elements/ranges.
  #
  # These are the elements that would have been in the sequence, had it continued without
  # interruption (without any of the gaps that gap_ranges detects), up until the end of the
  # receiver Enumerable.
  #
  # This only works with elements that respond to both +succ+ and +pred+ — in other words, it works
  # for Integers, but not Strings (unless you define your own +String#pred+).
  #
  def gap_elements
    gap_ranges(inclusive: false, single_element_ranges: true).
      flat_map(&:to_a)
  end
end

