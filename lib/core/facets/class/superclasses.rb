class Class
  # Returns a subset of `ancestors` that only includes classes (no modules) and does not include
  # self.
  #
  # In other words, it returns an array containing its superclass and (recursively) its superclass's
  # superclasses.
  #
  # Examples:
  #
  #   Array.superclasses           # => [Object, BasicObject]
  #   SimpleDelegator.superclasses # => [Delegator, BasicObject]
  #   User.superclasses            # => [ApplicationRecord, ActiveRecord::Base, Object, BasicObject]
  #
  # Other names considered: direct_ancestors, superclass_tree, lineage
  #
  # @author Tyler Rick
  #
  def superclasses
    if superclass
      [superclass] + superclass.superclasses
    else
      []
    end
  end

  # Alternative non-recursive implementation:
  #def superclasses
  #  ancestors.select { |ancestor| ancestor.is_a?(Class) && ancestor != self }
  #end
end
