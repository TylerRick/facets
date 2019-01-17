class String
  # Changes consecutive newlines groups into one newline each.
  # Similar to squish, but that collapses consecutive newlines (*any* whitespace) into a space
  # instead of a newline.
  def squish_lines
     gsub(/\n+/m, "\n")
  end

  def squish_lines!
     gsub!(/\n+/m, "\n")
  end
end
