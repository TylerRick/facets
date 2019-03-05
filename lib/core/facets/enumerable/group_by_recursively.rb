# Based on: https://stackoverflow.com/questions/15336841/creating-a-nested-hash-from-a-sorted-array-in-ruby-recursive-group-by

module Enumerable
  def group_by_recursively(*keys)
    groups = group_by(&keys.first)
    if keys.count <= 1
      groups
    else
      groups.merge(groups) do |group, elements|
        elements.group_by_recursively(*keys.drop(1))
      end
    end
  end
end
