covers 'facets/enumerable/flatten_as_hash_by_path'
covers 'facets/hash/unflatten_by_path'

require 'facets/kernel/respond_or_self'

test_case Enumerable do

  def check_each_path(i, a, e)
    a.assert == e
    a.each do |path, v|
      i.dig(*path).assert == v
    end
  end

  method :flatten_as_hash_by_path do

    dot_path = ->(path) { path.join('.') }

    test do
      i = {a: ['b', {c: 'c', d: 'd'}]}
      e = {"a.0"=>"b", "a.1.c"=>"c", "a.1.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      # flatten operation is reversible
      e.unflatten_by_dot_path(transform_key: ->(k) { k.respond_or_self.to_sym }).assert == i

      e = {[:a, 0]=>"b", [:a, 1, :c]=>"c", [:a, 1, :d]=>"d"}
      a = i.flatten_as_hash_by_path
      check_each_path(i, a, e)
      # flatten operation is reversible
      e.unflatten_by_path.assert == i
    end

    test do
      i = {:a=>1, :b=>{:b1=>1, :b2=>['1', '2']}}
      e = {"a"=>1, "b.b1"=>1, "b.b2.0"=>"1", "b.b2.1"=>"2"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
    end

    test do
      i = [0, {a: [0, 1, {c: 'c', d: 'd'}]}]
      e = {"0"=>0, "1.a.0"=>0, "1.a.1"=>1, "1.a.2.c"=>"c", "1.a.2.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
      e.unflatten_by_dot_path([], transform_key: ->(k) { k.respond_or_self.to_sym }).assert == i
      e.unflatten_by_dot_path.assert == {0=>0, 1=>{"a"=>[0, 1, {"c"=>"c", "d"=>"d"}]}}
    end

    test do
      i = [0, {a: [0, 1, {c: 'c', d: 'd'}]}]
      e = {"0"=>0, "1.a.0"=>0, "1.a.1"=>1, "1.a.2.c"=>"c", "1.a.2.d"=>"d"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e

      e = {[0]=>0, [1, :a, 0]=>0, [1, :a, 1]=>1, [1, :a, 2, :c]=>"c", [1, :a, 2, :d]=>"d"}
      a = i.flatten_as_hash_by_path
      check_each_path(i, a, e)
    end

    # https://final-form.org/docs/final-form/field-names
    test 'final-form example 1' do
      i = { bar: [ { frog: 'foo' } ] }
      e = {"bar.0.frog"=>"foo"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
    end
    test 'final-form example 2' do
      i = { bar: { frog: [ 'foo' ] } }
      e = {"bar.frog.0"=>"foo"}
      a = i.flatten_as_hash_by_dot_path
      a.assert == e
    end

  end

end


