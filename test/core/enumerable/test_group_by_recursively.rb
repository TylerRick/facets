covers 'facets/enumerable/group_by_recursively'

test_case Enumerable do
  method :group_by_recursively do
    test 'with 0 arguments' do
      result = ['a', 'b'].group_by_recursively.to_a
      result.assert == ['a', 'b'].group_by.to_a
      result.assert == ['a', 'b']
    end

    test 'with 1 symbols' do
      result = ['abc', '', 'a', ''].group_by_recursively(:empty?)
      result.assert == {
        false => ["abc", "a"],
        true  => ["", ""],
      }
    end

    test 'with 2 symbols' do
      result = ['abc', '', 'a', ''].group_by_recursively(:empty?, :length)
      result.assert == {
        false => {3=>["abc"], 1=>["a"]},
        true  => {0=>["", ""]},
      }
    end

    test 'with 2 procs' do
      subject = ['abc', 1, 'a', 234]
      result = subject.group_by_recursively(
        ->(_) {_.is_a? String },
        ->(_) {_.to_s.length }
      )
      result.assert == {
        false => {1=>[1],   3=>[234]},
        true  => {1=>["a"], 3=>["abc"]},
      }
    end
  end
end
