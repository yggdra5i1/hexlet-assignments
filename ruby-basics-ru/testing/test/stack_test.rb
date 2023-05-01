# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new
  end

  def test_push!
    @stack.push! 'ruby'
    assert { @stack.size == 1 }
  end

  def test_pop!
    @stack.pop!
    assert { @stack.size.empty? }
  end

  def test_clear!
    @stack.push! 'ruby'
    @stack.clear!
    assert { @stack.size.empty? }
  end

  def test_empty?
    @stack.push! 'ruby'
    refute { @stack.empty? }
    @stack.clear!
    assert { @stack.empty? }
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
