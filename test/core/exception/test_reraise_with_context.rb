covers 'facets/kernel/reraise_with_context'
covers 'facets/exception/reraise_with_context'

test_case Kernel do
  method :reraise_with_context do
    test 'simple' do
      reraise_with_context(some: 'context') do
        0.supercalafragalistic
      end rescue (exc = $!)
      exc.assert.kind_of? NoMethodError
      exc.context.assert == {some: 'context'}
    end

    test 'simple' do
      reraise_with_context(NameError, some: 'context') do
        0.supercalafragalistic
      end rescue (exc = $!)
      exc.assert.kind_of? NoMethodError
      exc.context.assert == {some: 'context'}
    end

    test 'non-matching exception class' do
      reraise_with_context(RuntimeError, some: 'context') do
        0.supercalafragalistic
      end rescue (exc = $!)
      exc.assert.kind_of? NoMethodError
      exc.context.assert == nil
    end

    test 'adding context from a loop' do
      [2, 1, 0].each do |n|
        reraise_with_context(n: n) do
          10 / n
        end
      end rescue (exc = $!)
      exc.assert.kind_of? ZeroDivisionError
      exc.context.assert == {n: 0}
    end
  end
end

test_case Exception do
  class_method :reraise_with_context do
    test 'simple' do
      NameError.reraise_with_context(some: 'context') do
        0.supercalafragalistic
      end rescue (exc = $!)
      exc.assert.kind_of? NoMethodError
      exc.context.assert == {some: 'context'}
    end

    test 'non-matching exception class' do
      RuntimeError.reraise_with_context(some: 'context') do
        0.supercalafragalistic
      end rescue (exc = $!)
      exc.assert.kind_of? NoMethodError
      exc.context.assert == nil
    end

    test 'adding context from a loop' do
      [3, 2, 1, 0].each do |n|
        StandardError.reraise_with_context(n: n) do
          10 / n
        end
      end rescue (exc = $!)
      exc.context.assert == {n: 0}
    end
  end
end
