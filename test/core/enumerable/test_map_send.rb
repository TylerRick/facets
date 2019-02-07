covers 'facets/enumerable/map_send'
# Add example for something like (add new method if needed):
# global_variables.map {|x| send x }
# global_variables.map {|x| eval x }
#   global_variables.map_send(&:eval) ?


test_case Enumerable do

  method :map_send do

    test do
      [1,2,3].map_send(:+, 3).assert == [4,5,6]
    end

  end

  #method :map_send do
  #  test do
  #    r = [1,2,3].map_send(:+, 1)
  #    assert_equal(r, [2,3,4])
  #  end
  #
  #  test "with_block" do
  #    r = [1,2,3].map_send(:+,1){ |x| x + 1 }
  #    assert_equal(r, [3,4,5])
  #  end
  #end

end

