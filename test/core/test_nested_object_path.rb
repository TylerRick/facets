covers 'facets/nested_object_path'

test_case NestedObjectPath do

  class_method :to_dot_path do

    test do
      input = ['bar', 'frog']
      NestedObjectPath.to_dot_path(input).        assert == 'bar.frog'
      NestedObjectPath.to_dot_bracket_path(input).assert == 'bar.frog'
      NestedObjectPath.to_bracket_path(input).    assert == 'bar[frog]'
    end
    test do
      input = ['bar', 0]
      NestedObjectPath.to_dot_path(input).        assert == 'bar.0'
      NestedObjectPath.to_dot_bracket_path(input).assert == 'bar[0]'
      NestedObjectPath.to_bracket_path(input).    assert == 'bar[0]'
    end
    test do
      input = [:bar, 0, :frog]
      NestedObjectPath.to_dot_path(input).        assert == 'bar.0.frog'
      NestedObjectPath.to_dot_bracket_path(input).assert == 'bar[0].frog'
      NestedObjectPath.to_bracket_path(input).    assert == 'bar[0][frog]'
    end

  end

end

