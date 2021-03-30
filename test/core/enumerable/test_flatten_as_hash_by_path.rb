covers 'facets/enumerable/flatten_as_hash_by_path'
covers 'facets/hash/unflatten_by_path'

require 'facets/kernel/respond_or_self'

test_case Enumerable do

  def assert_each_path_diggable(i, a, e)
    a.assert == e
    a.each do |path, v|
      i.dig(*path).assert == v
    end
  end

  # Tests that the flatten operation is reversible
  def assert_reversible(i, *unflatten_args)
    a = i.flatten_as_hash_by_dot_path
    a.unflatten_by_string_path(*unflatten_args).assert == i

    a = i.flatten_as_hash_by_dot_bracket_path
    a.unflatten_by_string_path(*unflatten_args).assert == i

    a = i.flatten_as_hash_by_bracket_path
    a.unflatten_by_string_path(*unflatten_args).assert == i
  end

  method :flatten_as_hash_by_path do
  # also:
  # method :flatten_as_hash_by_dot_path
  # method :flatten_as_hash_by_dot_bracket_path
  # method :flatten_as_hash_by_bracket_path
  # test_case Hash
  # method :unflatten_by_path
  # method :unflatten_by_string_path

    test do
      i = {a: ['b', {c: 'c', d: 'd'}]}
      e = {[:a, 0]=>"b", [:a, 1, :c]=>"c", [:a, 1, :d]=>"d"}
      a = i.flatten_as_hash_by_path
      assert_each_path_diggable(i, a, e)
      # flatten operation is reversible
      e.unflatten_by_path.assert == i

      e = {"a.0"=>"b", "a.1.c"=>"c", "a.1.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      # flatten operation is reversible
      assert_reversible i
      # Uses :to_sym by default but can opt out
      e.unflatten_by_string_path(transform_key: nil).assert == {"a"=>["b", {"c"=>"c", "d"=>"d"}]}
    end

    test do
      i = {:a=>1, :b=>{:b1=>1, :b2=>['1', '2']}}
      e = {"a"=>1, "b.b1"=>1, "b.b2.0"=>"1", "b.b2.1"=>"2"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      assert_reversible i
    end

    test 'array' do
      i = [0, {a: [0, 1, {c: 'c', d: 'd'}]}]
      e = {"0"=>0, "1.a.0"=>0, "1.a.1"=>1, "1.a.2.c"=>"c", "1.a.2.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      assert_reversible i, []

      # Assumes {} by default
      e.unflatten_by_string_path.assert != i
      e.unflatten_by_string_path.assert == {0=>0, 1=>{a: [0, 1, {c: 'c', d: 'd'}]}}
      # But you can tell it to use a [] 
      e.unflatten_by_string_path([]).assert == i
    end

    test 'array' do
      i = [0, {a: [0, 1, {c: 'c', d: 'd'}]}]
      e = {"0"=>0, "1.a.0"=>0, "1.a.1"=>1, "1.a.2.c"=>"c", "1.a.2.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      assert_reversible i, []

      e = {[0]=>0, [1, :a, 0]=>0, [1, :a, 1]=>1, [1, :a, 2, :c]=>"c", [1, :a, 2, :d]=>"d"}
      a = i.flatten_as_hash_by_path
      assert_each_path_diggable(i, a, e)
    end

    # https://final-form.org/docs/final-form/field-names
    test 'final-form example 1' do
      i = { bar: [ { frog: 'foo' } ] }
      e = {"bar.0.frog"=>"foo"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      assert_reversible i
    end
    test 'final-form example 2' do
      i = { bar: { frog: [ 'foo' ] } }
      e = {"bar.frog.0"=>"foo"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      assert_reversible i
    end

  end

end


