covers 'facets/enumerable/gaps'

test_case Enumerable do

  method :gap_ranges do

    test "a non-decreasing-sequence mixed Array of Integers and Ranges" do
      [0, 2..3, 5..6, 4..7, 13].gap_ranges.assert == \
      [0..2, 3..5, 6..4, 7..13]
    end

    test "a non-decreasing-sequence Array of Ranges" do
      [-1..1, 3..4, 7..8].gap_ranges.assert == \
      [    1..3, 4..7   ]

      [-1..1, 3..4,    7..8].gap_elements.assert == \
      [      2,    5,6,    ]
    end

    test "a non-decreasing-sequence Array of Ranges (inclusive: false)" do
      [-1..1,     3..4,    7..8].gap_ranges(inclusive: false).assert == \
      [      2..2,     5..6   ]
    end

    test "a non-decreasing-sequence Array of Ranges (inclusive: false, single_element_ranges: false)" do
      [-1..1, 3..4,    7..8].gap_ranges(inclusive: false, single_element_ranges: false).assert == \
      [      2,    5..6   ]

      [-1..1, 3..4,    7..8].gap_elements.assert == \
      [      2,    5,6   ]
    end

    test "a non-non-decreasing-sequence Array of Ranges" do
      [1..3, 2..4].gap_ranges.assert == \
      [   3..2]

      [0..0, 5..6, 4..7, 13..13].gap_ranges.assert == \
      [   0..5, 6..4, 7..13]
    end

  end

  method :gap_elements do
  end

end

