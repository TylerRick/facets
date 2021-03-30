covers 'facets/enumerable/set_at_path'

test_case Enumerable do

  method :set_at_path do

    test do
      {}.set_at_path([:a, 0, :b], 4).
        assert == { a: [ { b: 4 } ] }
      {}.set_at_path('a.0.b', 4).
        assert == { a: [ { b: 4 } ] }
    end

    test do
      TypeError.assert.raised? {
      [].set_at_path([:a, 0, :b], 4) }
      [].set_at_path([0, :a, 0, :b], 4).
          assert == [ { a: [ { b: 4 } ] } ]
    end

    # These tests based on https://final-form.org/docs/final-form/field-names
    test do
      path = ['bear']
      spath = 'bear'
      {}.set_at_path(path,  'zoo').assert == { 'bear' => 'zoo' }
      {}.set_at_path(spath, 'zoo').assert == {  bear: 'zoo' }

      # We can't use non-Integer as an index into an array!
      TypeError.assert.raised? { [].set_at_path(path,  'zoo') }
      TypeError.assert.raised? { [].set_at_path(spath, 'zoo') }
      # The alternative would be to add an extra level of nesting (self << { key => value }), which
      # is what dam13n's original version did, but:
      # 1. It would be surprising to have it automatically add an extra level of nesting that we
      #   didn't explicitly include in the path.
      # 2. Doing so would break "diggability": we couldn't dig at the same path and get the value
      #   that we just (supposedly) burried at that path.
      # 3. We don't need to be that "safe"; to be consistent with dig, we should actually raise an
      #   error if we can't actually dig/bury at any subpath within that path.

      {}.set_at_path(path,  'zoo', transform_key: false).assert == { 'bear' => 'zoo' }
      {}.set_at_path(spath, 'zoo', transform_key: false).assert == { 'bear' => 'zoo' }
    end

    test do
      path = [:bear, :frog]
      spath = 'bear.frog'
      apath = [0, *path]
      {}.set_at_path(path,  'zoo').assert ==  { bear: { frog: 'zoo' } }
      {}.set_at_path(spath, 'zoo').assert ==  { bear: { frog: 'zoo' } }
      [].set_at_path(apath, 'zoo').assert == [{ bear: { frog: 'zoo' } }]
    end

    test do
      path = [:bear, 0]
      spath = 'bear.0'
      apath = [0, *path]
      {}.set_at_path(path,       'zoo').assert ==  { bear: [ 'zoo' ] }
      {}.set_at_path(spath,      'zoo').assert ==  { bear: [ 'zoo' ] }
      [].set_at_path(apath, 'zoo').assert == [{ bear: [ 'zoo' ] }]
    end

    test do
      path = [:bear, 1]
      spath = 'bear[1]'
      apath = [0, *path]
      {}.set_at_path(path,  'zoo').assert ==  { bear: [ nil, 'zoo' ] }
      {}.set_at_path(spath, 'zoo').assert ==  { bear: [ nil, 'zoo' ] }
      [].set_at_path(apath, 'zoo').assert == [{ bear: [ nil, 'zoo' ] }]
    end

    test do
      path =  [0, :bear]
      spath = '0.bear'
      {}.set_at_path(path,  'zoo').assert == {0 => { bear: 'zoo' }}
      {}.set_at_path(spath, 'zoo').assert == {0 => { bear: 'zoo' }}
      [].set_at_path(path,  'zoo').assert == [     { bear: 'zoo' }]
    end

    test do
      path = [:bear, 0, :frog]
      spath = 'bear[0].frog'
      apath = [0, *path]
      {}.set_at_path(path,  'zoo').assert ==  { bear: [ {frog: 'zoo'} ] }
      {}.set_at_path(spath, 'zoo').assert ==  { bear: [ {frog: 'zoo'} ] }
      [].set_at_path(apath, 'zoo').assert == [{ bear: [ {frog: 'zoo'} ] }]
    end

    test do
      path = [:bear]
      spath = 'bear'
      o =    { bear: 'foo' }
      o.set_at_path(path,  nil).assert ==  { bear: nil }
      o.set_at_path(spath, nil).assert ==  { bear: nil }
    end

    test do
      path = [:bear, :frog]
      spath = 'bear.frog'
      o =    { bear: { frog: 'zoo' }, other: 42 }
      o.set_at_path(path,  nil).assert ==  { bear: {frog: nil}, other: 42 }
      o.set_at_path(spath, nil).assert ==  { bear: {frog: nil}, other: 42 }
    end

    test do
      path = [:bear, :frog, 0]
      spath = 'bear.frog[0]'
      o =    { bear: { frog: ['zoo'] } }
      o.set_at_path(path,  nil).assert ==  { bear: {frog: [nil]} }
      o.set_at_path(spath, nil).assert ==  { bear: {frog: [nil]} }
    end

  end

end


