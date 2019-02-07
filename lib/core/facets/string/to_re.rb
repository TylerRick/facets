require 'facets/regexp/parse_options_string'

class String

  # Turns a string into a regular expression.
  #
  #   "a?".to_re  #=> /a?/
  #
  # If +esc+ is true (default is false), escapes the string.
  #
  # If +options+ are specified, they may either be a String containing single-letter options flags,
  # as documented [here](https://ruby-doc.org/core/Regexp.html#class-Regexp-label-Options), or an
  # Integer or nil or false, as documented for [Regexp.new
  # reference](https://ruby-doc.org/core/Regexp.html#method-c-new).
  #
  # Question: Should we to allow options as first option (rename to esc_or_options) or would that be
  # too confusing? Maybe just add Regexp.new_with_options_string to give a nicer interface (which
  # assumes you've already handled escaping as needed.)
  #
  # CREDIT: Trans, Tyler Rick

  def to_re(esc = false, options = nil)
    options =
      case options
      when String
        Regexp.parse_options_string(options)
      else
        options
      end

    Regexp.new((esc ? Regexp.escape(self) : self), options)
  end

  def to_rx(esc = true, options = nil)
    to_re(esc, options)
  end

end
