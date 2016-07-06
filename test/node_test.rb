require 'minitest/autorun'
require 'minitest/pride'
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
    a1 = n.flag
    n.flag = true
    a2 = n.flag
    assert_equal false, a1
    assert_equal true, a2
  end

  def test_a_node_has_weight
    n = Node.new
    assert_equal nil, n.weight
  end


end
