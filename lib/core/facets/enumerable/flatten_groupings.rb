module Enumerable
  # Takes an array (not grouped) or a hash with elements grouped by keys (such as one returned by
  # group_by or group_by_recursively) and flattens it into an array of groupings.
  #
  # A grouping is an array consisting of:
  # - the key for that grouping
  # - the elements in that grouping
  # - the depth
  #
  # Example:
  #   {
  #     a: {
  #       'a.a': ['a.a.1', 'a.a.2'],
  #       'a.b': ['a.b.1'],
  #     },
  #     b: {
  #       'b.a': ['b.a.1', 'b.a.2'],
  #       'b.b': ['b.b.1'],
  #     }
  #   }.flatten_groupings
  #   => [
  #     [
  #       :'a',
  #       [],
  #       1
  #     ],
  #     [
  #       :'a.a',
  #       ['a.a.1', 'a.a.2'],
  #       2
  #     ],
  #     [
  #       :'a.b',
  #       ['a.b.1'],
  #       2
  #     ],
  #     …
  #   ]
  def flatten_groupings(depth = 1)
    if is_a? Hash
      [].tap do |flattened|
        each do |k, v|
          if v.is_a? Hash
            flattened << [k, [], depth]
            flattened.concat v.flatten_groupings(depth + 1)
          else
            flattened << [k, v, depth]
          end
        end
      end
    else
      # self is already a flat Array (a single, ungrouped "grouping")
      [
        [nil, self, 0]
      ]
    end
  end
end
