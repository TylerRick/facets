module Enumerable

  # Clusters together adjacent elements that share the property given by a block into a list of
  # sub-arrays.
  #
  #     [2,2,2,3,3,4,2,2,1].cluster{ |x| x }
  #     => [[2, 2, 2], [3, 3], [4], [2, 2], [1]]
  #
  #     ["dog", "duck", "cat", "dude"].cluster{ |x| x[0] }
  #     => [["dog", "duck"], ["cat"], ["dude"]]
  #
  # @author Oleg K, Tyler Rick

  if RUBY_VERSION >= '2.3'

    def cluster
      chunk_while { |prev, element|
        yield(prev) == yield(element)
      }.to_a
    end

  else

    def cluster
      clusters = []
      each do |element|
        if clusters.last && yield(clusters.last.last) == yield(element)
          clusters.last << element
        else
          clusters << [element]
        end
      end
      clusters
    end

  end

end

