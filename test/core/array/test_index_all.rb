covers 'facets/array/index_all'

module IndexAllCommon
end

test_case Enumerable do

  method :index_all do

    test "no argument or block" do
      %w[a b c].index_all.class.assert == Enumerator
      (?a..?c). index_all.class.assert == Enumerator
      %w[a b c].index_all.to_a.assert == [0, 1, 2]
      (?a..?c). index_all.to_a.assert == [0, 1, 2]
    end

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

    test "very large receiver, very many matches" do
      (1..2**5).    index_all(2).first(1).assert == [1]
    end

  end

end

test_case Enumerator::Lazy do
  method :index_all do

    test "no argument or block" do
      %w[a b c].lazy.index_all.class.assert == Enumerator::Lazy
      %w[a b c].lazy.index_all.to_a.assert == [0, 1, 2]
    end

    test "with argument, no match" do
      %w[a b c].lazy.index_all('z').force.assert == []
    end

    test "with block, no match" do
      %w[a b c].lazy.index_all {|x| x == 'z' }.force.assert == []
    end

    test "with argument, 1 match" do
      [1, 2, 3].lazy.index_all(2).  force.assert == [1]
      %w[a b c].lazy.index_all('b').force.assert == [1]
    end

    test "with block, 1 match" do
      [1, 2, 3].lazy.index_all {|x| x == 2 }.force.assert == [1]
      %w[a b c].lazy.index_all {|x| x.upcase == 'B' }.force.assert == [1]
    end

    test "with argument, 2 matches" do
      [1, 2, 2].    lazy.index_all(2).force.assert == [1, 2]
      [1,2,2,3,3,3].lazy.index_all(2).force.assert == [1, 2]
      [1,2,2,3,3,3].lazy.index_all(3).force.assert == [3, 4, 5]
      %w[a b B c].lazy.index_all {|x| x.upcase == 'B' }.force.assert == [1, 2]
    end

    test "infinitely large enumerable" do
      (1..Float::INFINITY).lazy.index_all(2).first(1).assert == [1]
    end

    test "infinitely large enumerable, infinitely many matches" do
      (1..Float::INFINITY).lazy.index_all {|i| i.odd? }.first(5).assert == [0, 2, 4, 6, 8]
      (1..Float::INFINITY).lazy.map {|i| i.odd? ? i - 1 : i }.map(&:to_s).index_all {|el| el.to_i.even? }.first(5).assert == [0, 1, 2, 3, 4]
    end
  end
end
