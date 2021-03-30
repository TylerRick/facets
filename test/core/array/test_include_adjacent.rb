#covers 'facets/array/include_adjacent'
#
#test_case Array do
#
#  method :include_adjacent? do
#
#    test "non-elements" do
#      [1, 2, 3].include_adjacent?(3, 4).assert == false
#    end
#
#    test "non-elements" do
#      [1, 2, 3].include_adjacent?(4, 5).assert == false
#    end
#
#    test "include_adjacent elements" do
#      [1, 2, 3].include_adjacent?(1, 2, 3).assert == true
#      [1, 2, 3].include_adjacent?(2, 3).assert == true
#    end
#
#    test "non-include_adjacent elements" do
#      [1, 2, 3].include_adjacent?(1, 3).assert == false
#    end
#  end
#
#end
#
