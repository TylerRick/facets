covers 'facets/enumerable/flatten_groupings'

test_case Enumerable do
  method :flatten_groupings do
    test '0 levels deep' do
      subject = ['1', '2']
      subject.flatten_groupings.assert == [
        [nil, ['1', '2'], 0]
      ]
    end

    test '1 level deep' do
      subject = {
        a: ['a.1', 'a.2'],
        b: ['b.1', 'b.2'],
      }
      subject.flatten_groupings.assert == [
        [
          :'a',
          ['a.1', 'a.2'],
          1
        ],
        [
          :'b',
          ['b.1', 'b.2'],
          1
        ],
      ]
    end

    test '2 levels deep' do
      subject = {
        a: {
          'a.a': ['a.a.1', 'a.a.2'],
          'a.b': ['a.b.1'],
        },
        b: {
          'b.a': ['b.a.1', 'b.a.2'],
          'b.b': ['b.b.1'],
        }
      }
      subject.flatten_groupings.assert == [
        [
          :'a',
          [],
          1
        ],
        [
          :'a.a',
          ['a.a.1', 'a.a.2'],
          2
        ],
        [
          :'a.b',
          ['a.b.1'],
          2
        ],
        [
          :'b',
          [],
          1
        ],
        [
          :'b.a',
          ['b.a.1', 'b.a.2'],
          2
        ],
        [
          :'b.b',
          ['b.b.1'],
          2
        ],
      ]
    end

    test '3 levels deep' do
      subject = {
        a: {
          'a.a': {
            'a.a.a': ['a.a.a.1', 'a.a.a.2']
          }
        },
        b: {
          'b.a': {
            'b.a.a': ['b.a.a.1', 'b.a.a.2'],
          },
        }
      }
      subject.flatten_groupings.assert == [
        [
          :'a',
          [],
          1
        ],
        [
          :'a.a',
          [],
          2
        ],
        [
          :'a.a.a',
          ['a.a.a.1', 'a.a.a.2'],
          3
        ],
        [
          :'b',
          [],
          1
        ],
        [
          :'b.a',
          [],
          2
        ],
        [
          :'b.a.a',
          ['b.a.a.1', 'b.a.a.2'],
          3
        ],
      ]
    end
  end
end
