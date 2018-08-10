covers 'facets/array/index_all'

test_case Array do

  method :index_all do

    test "with argument, no match" do
      %w[a b c].index_all('z').assert == []
    end

    test "with block, no match" do
      %w[a b c].index_all {|x| x == 'z' }.assert == []
    end

    test "with argument, 1 match" do
      [1, 2, 3].index_all(2).  assert == [1]
      %w[a b c].index_all('b').assert == [1]
    end

    test "with block, 1 match" do
      [1, 2, 3].index_all {|x| x == 2 }.assert == [1]
      %w[a b c].index_all {|x| x.upcase == 'B' }.assert == [1]
    end

    test "with argument, 2 matches" do
      [1, 2, 2].    index_all(2).assert == [1, 2]
      [1,2,2,3,3,3].index_all(2).assert == [1, 2]
      [1,2,2,3,3,3].index_all(3).assert == [3, 4, 5]
      %w[a b B c].index_all {|x| x.upcase == 'B' }.assert == [1, 2]
    end

  end

end


