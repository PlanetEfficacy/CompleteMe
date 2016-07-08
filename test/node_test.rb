require_relative 'test_helper'
require_relative '../lib/node'

class NodeTest < Minitest::Test
  def test_it_can_create_a_node
    n = Node.new
    assert n
  end

  def test_a_node_has_children
    n = Node.new
    assert_equal n.children, {}
  end

  def test_a_node_has_a_flag_initialized_to_false
    n = Node.new
    assert_equal false, n.flag
  end

  def test_a_node_flag_can_be_changed
    n = Node.new
    n2 = Node.new
    n.flag = true

    a1 = n.flag
    a2 = n2.flag

    assert_equal true, a1
    assert_equal false, a2
  end

  def test_a_node_has_weight
    n = Node.new
    assert_equal Hash.new, n.weight
  end

  def test_a_node_knows_if_it_has_children
    n = Node.new
    n2 = Node.new

    n.children["a"] =  n2

    assert n.has_children?
  end

  def test_a_node_knows_if_it_does_not_have_children?
    n = Node.new
    assert n.does_not_have_children?
  end

end
