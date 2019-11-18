class String
  # Is this a string representation of an integer?
  #
  # Note that this doesn't check simply whether this string *can* be converted to an integer with
  # to_i (because *every* string can be converted in that way, so it wouldn't be a very useful
  # test), but rather whether the string is *already* an integer.
  #
  # > '100%'.integer?
  # => false
  # > '100'.integer?
  # => true
  # > '100%'.to_i.is_a?(Integer)
  # => true
  # > '100'.is_a?(Integer)
  # => false
  #
  # See also Integer#integer? Using a different name other than `integer?` so that code won't see
  # that an object responds to integer?, send that message, mistakenly conclude that it is *already*
  # an Integer (which is the meaning used by Numeric#integer?).
  #
  def to_integer?
    Integer(self) rescue return false
    true
  end

  def to_integer
    Integer(self) rescue return nil
  end

  def to_integer!
    Integer(self)
  end
end
