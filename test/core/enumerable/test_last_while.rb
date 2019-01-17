#covers 'facets/enumerable/first_while'
covers 'facets/enumerable/last_while'
require 'delegate'

test_case Enumerable do
  method :last_while do
    test "using .to_a to get all 3 last 0s" do
      [1, 1, 0, 1, 0, 0, 0].last_while(&:zero?).to_a.assert == \
                  [0, 0, 0]
    end

    test "using .to_a to get all 0 last 0s" do
      [1, 1, 0, 1].last_while(&:zero?).to_a.assert == \
      []
    end


    test "using last_while(5) to get all 3 last 0s" do
      [1, 1, 0, 1, 0, 0, 0].last_while(5, &:zero?).to_a.assert == \
                  [0, 0, 0]
    end

    test "using last_while(5).take(2) to get 3 last 0s" do
      [1, 1, 0, 1, 0, 0, 0].last_while(5, &:zero?).take(2).assert == \
                     [0, 0]
    end

    test "using last_while(5) to get all 0 last 0s" do
      [1, 0, 0, 1].last_while(5, &:zero?).to_a.assert == \
      []
    end


    test "using .to_a to get all 3 last nils" do
      [1, 1].last_while(&:zero?).to_a.assert == \
      []
    end

    test "using .to_a to get all 3 last nils" do
      [1, nil, nil, 1, nil, nil, nil].last_while(&:nil?).to_a.assert == \
                      [nil, nil, nil]
    end

#    test 'works with infinite enums' do
#    end
  end

  method :last do
    klass = Class.new(SimpleDelegator) do
      include Enumerable
    end

    test "get last element" do
      klass.new([1, 0]).last.assert == \
                    0
    end

    test "get last 4 elements" do
      klass.new([1, 1, 0, 1, 0, 0, 0]).last(4).to_a.assert == \
               [1, 0, 0, 0]
    end
  end
end
