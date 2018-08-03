covers 'facets/enumerable/contiguous'

test_case Enumerable do

  method :contiguous_chunks do

    test "on an array, non-increasing" do
      [0, 2, 3, 5, 6, 4, 5, 6, 7, 13].chunk_succ.assert == \
      [[0], [2, 3], [5, 6], [4, 5, 6, 7], [13]]
    end

    test "on an array, with repeated elements (still monotonically increasing)" do
      [0, 2, 3, 5, 6, 6, 7, 13].chunk_succ.assert == \
      [[0], [2, 3], [5, 6], [6, 7], [13]]
    end

    test "on an array, increasing" do
      [-1, 0, 1, 3, 4, 7, 8].chunk_succ.assert == \
      [[-1, 0, 1], [3, 4], [7, 8]]
    end

    test "on an array of characters" do
      ['a', 'b', 'd', 'm', 'x', 'y', 'z'].chunk_succ.assert == \
      [['a', 'b'], ['d'], ['m'], ['x', 'y', 'z']]
    end

    test "on an array of strings" do
      ['cow', 'cox', 'coy', 'mat', 'may', 'maz'].chunk_succ.assert == \
      [['cow', 'cox', 'coy'], ['mat'], ['may', 'maz']]
    end

=begin
custom GradeLevel object
planet#succ

    test "on a hash" do
      h = {0=>0, 1=>2, 2=>4, 3=>6, 4=>8, 5=>1, 6=>3, 7=>5, 8=>7, 9=>9}
      e = [[[0, 0], [1, 2], [2, 4], [3, 6], [4, 8]], [[5, 1], [6, 3], [7, 5], [8, 7], [9, 9]]]
      r = h.cluster{ |k, v| v % 2 }.each{|a| a.sort!}
      r.assert == e
    end

    test "on an empty array" do
      r = [].cluster{ |a| a }
      r.assert == []
    end
=end

  end

  method :contiguous_ranges do

    test "on an array, non-increasing" do
      [0,    2, 3, 5, 6, 4, 5, 6, 7, 13    ].contiguous_ranges.assert == \
      [0..0, 2..3, 5..6, 4   ..   7, 13..13]
    end

    test "on an array, non-increasing (single_element_ranges: false)" do
      [0, 2, 3, 5, 6, 4, 5, 6, 7, 13].contiguous_ranges(single_element_ranges: false).assert == \
      [0, 2..3, 5..6, 4   ..   7, 13]
    end

=begin
    test "on an array, with repeated elements (still monotonically increasing)" do
      [0, 2, 3, 5, 6, 6, 7, 13].contiguous_ranges.assert == \
      [[0], [2, 3], [5, 6], [6, 7], [13]]
    end

    test "on an array, increasing" do
      [-1, 0, 1, 3, 4, 7, 8].contiguous_ranges.assert == \
      [[-1, 0, 1], [3, 4], [7, 8]]
    end

    test "on an array of characters" do
      ['a', 'b', 'd', 'm', 'x', 'y', 'z'].contiguous_ranges.assert == \
      [['a', 'b'], ['d'], ['m'], ['x', 'y', 'z']]
    end

    test "on an array of strings" do
      ['cow', 'cox', 'coy', 'mat', 'may', 'maz'].contiguous_ranges.assert == \
      [['cow', 'cox', 'coy'], ['mat'], ['may', 'maz']]
    end

custom Planet object
planet#succ

    test "on a hash" do
      h = {0=>0, 1=>2, 2=>4, 3=>6, 4=>8, 5=>1, 6=>3, 7=>5, 8=>7, 9=>9}
      e = [[[0, 0], [1, 2], [2, 4], [3, 6], [4, 8]], [[5, 1], [6, 3], [7, 5], [8, 7], [9, 9]]]
      r = h.cluster{ |k, v| v % 2 }.each{|a| a.sort!}
      r.assert == e
    end

    test "on an empty array" do
      r = [].cluster{ |a| a }
      r.assert == []
    end
=end

  end
end

