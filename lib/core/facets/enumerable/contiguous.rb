module Enumerable
  # Returns all contiguous, increasing sub-sequences within a sequence/collection — that is,
  # chunks/clusters of adjacent elements where each element in the chunk is successively next in
  # sequence (as defined by the element's succ method).
  #
  # [-1, 0, 1, 3, 4, 7, 8].contiguous_chunks
  # => [[-1, 0, 1], [3, 4], [7, 8]]
  #
  # Also aliased as chunk_succ.
  #
  # Other names considered: clusters_of_contiguous, contiguous_sequences, chunk_by_succ,
  # chunks_of_succ, chunk_when_succ, increasing_sequences, sequences
  #
  # @author Tyler Rick
  #
  def contiguous_chunks
    chunk_while { |prev, element|
      prev.succ == element
    }.to_a
  end

  alias_method :chunk_succ, :contiguous_chunks


  # Returns an array of ranges, each range representing a range of contiguous elements from self.
  #
  # Contiguous is defined here as being "next or together in sequence", with each element being
  # successively next in sequence (as defined by the element's succ method).
  #
  # [-1, 0, 1, 3, 4, 7, 8].contiguous_ranges
  # => [-1..1, 3..4, 7..8]
  #
  # @author Tyler Rick
  #
  # Other names considered: ranges_of_contiguous, sequence_ranges
  #
  def contiguous_ranges(single_element_ranges: true)
    chunk_succ.map { |chunk|
      if !single_element_ranges && chunk.length == 1
        chunk[0]
      else
        chunk[0] .. chunk[-1]
      end
    }
  end

=begin
  # Original implementation:
  def contiguous_ranges
    ranges = []
    each do |element|
      range = ranges.last
      if range && range.end.succ == element
        ranges[-1] = (range.begin .. element)
      else
        ranges << (element .. element)
      end
    end
    ranges
  end
=end
end
