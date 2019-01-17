covers 'facets/enumerable/first_while'

test_case Enumerable do
  method :first_while do
    test "using .to_a to get all 3 first 0s" do
      [0, 0, 0, 1, 0, 1, 1].first_while(&:zero?).to_a.assert == \
      [0, 0, 0]
    end

    test "using .to_a to get all 0 first 0s" do
      [1, 1, 0, 1].first_while(&:zero?).to_a.assert == \
      []
    end


    test "using first_while(5) to get all 3 first 0s" do
      [0, 0, 0, 1, 0, 1, 1].first_while(5, &:zero?).assert == \
      [0, 0, 0]
    end

    test "using first(5).take(2) to get 3 first 0s" do
      [0, 0, 0, 1, 0, 1, 1].first_while(5, &:zero?).take(2).assert == \
      [0, 0]
    end

    test "using first_while(5) to get all 0 first 0s" do
      [1, 0, 0, 1].first_while(5, &:zero?).assert == \
      []
    end


    test "using .to_a to get all 0 first nils" do
      [1, 1].first_while(&:zero?).to_a.assert == \
      []
    end

    test "using .to_a to get all 3 first nils" do
      [nil, nil, nil, 1, nil, nil, 1].first_while(&:nil?).to_a.assert == \
      [nil, nil, nil]
    end

#    test 'works with infinite enum' do
#    end
  end
end

