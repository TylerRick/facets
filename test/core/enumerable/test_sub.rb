covers 'facets/enumerable/sub'

require 'byebug'

test_case Enumerable do
  method :gsub do
    test do
      a = [1, 3, 3, 4]
      a.gsub(9, 99).assert == a
    end

    test do
      a = [1, 2, 3]
      a.gsub(3, 99).assert == [1, 2, 99]
    end

    test do
      a = [1, 3, 3, 4]
      a.gsub(3, [2, 3]).assert == [1, [2, 3], [2, 3], 4]
    end

    test do
      a = [1, 3, 3, 4]
      a.gsub(3) {|i| i+1 }.assert == [1, 4, 4, 4]
    end

    test do
      a = (1..4)
      a.gsub(2..3, '*').assert == [1, '*', '*', 4]
    end

    test do
      a = "hello".chars
      a.gsub(/[aeiou]/, '*').assert ==
          "h*ll*".chars
    end

    test do
      a = "hello".chars
      # To do: Is there any way to get $1 to be set in the block, like it is with String#gsub?
      #   a.gsub(/([aeiou])/) { "<#{$1}>" }.assert ==
      a.gsub(/([aeiou])/) { |_, m| "<#{m[1]}>" }.assert ==
        ['h', '<e>', 'l', 'l', '<o>']
    end

    test do
      a = "hello".chars
      a.gsub(/./) {|s| s.ord }.assert ==
        [104, 101, 108, 108, 111]
    end

    test 'does not handle argument 2 Hash in the same way as String#gsub' do
      a = "hello".chars
      hash = {'e' => 3, 'o' => '*'}
      a.gsub(/[eo]/, hash).assert ==
         ['h', hash, 'l', 'l', hash]
    end
  end

  method :sub do
    test do
      a = [1, 3, 3, 4]
      a.sub(3, [2, 3]).assert == [1, [2, 3], 3, 4]
    end
  end
end

test_case Array do
  method :gsub! do
    test do
      a = [1, 3, 3, 4]
      a.gsub!(3, [2, 3])
      a.assert == [1, [2, 3], [2, 3], 4]
    end
  end

  method :sub! do
    test do
      a = [1, 3, 3, 4]
      a.sub!(3, [2, 3])
      a.assert == [1, [2, 3], 3, 4]
    end
  end
end
