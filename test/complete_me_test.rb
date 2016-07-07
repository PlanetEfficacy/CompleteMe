require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'

class CompleteMeTest < Minitest::Test
  # def setup
  #   c = CompleteMe.new
  # end

  def test_it_can_create_a_CompleteMe
    c = CompleteMe.new
    assert c
  end

  def test_a_CompleteMe_has_a_root
    c = CompleteMe.new
    assert c.root
  end

  def test_a_CompleteMe_has_a_root_that_is_a_node
    c = CompleteMe.new
    root = c.root
    class_name = root.class.name
    assert_equal "Node", class_name
  end

  def test_a_CompleteMe_can_update_word_count
    c = CompleteMe.new
    c.insert("pizza")
    assert_equal 1, c.count
    c.insert("pizzeria")
    assert_equal 2, c.count
  end

  def test_can_see_root_node
    c = CompleteMe.new
    c.insert("pizza")
    assert_instance_of Node, c.root
  end

  def test_it_can_insert_word
    c = CompleteMe.new
    c.insert("pizza")
    expected_node_keys = ["p", "i", "z", "z", "a"]
    node_keys = []
    node = c.root
    while node.children.keys.length > 0
      node_keys << node.children.keys[0]
      node = node.children[node.children.keys[0]]
    end
    assert_equal node_keys, expected_node_keys
  end

  def test_it_knows_pizza_is_in_the_dictionary
    skip
    c = CompleteMe.new
    c.insert("pizza")
    assert_equal ["pizza"], c.suggest("pizza")
  end

  def test_it_can_suggest_word_from_prefix
    c = CompleteMe.new
    c.insert("pizza")
    assert_equal ["pizza"], c.suggest("piz")
  end

  def test_it_can_insert_words
    skip
    c = CompleteMe.new
    c.insert("pizza")
    c.insert("pizzeria")
    expected_node_keys = ["p", "i", "z", "z", "a", "e", "r", "i", "a"]
    node_keys = []
    node = c.root
    until node.children.keys.length == 0
      node_keys << node.children.keys[0]
      node = node.children[node.children.keys[0]]
    end
    assert_equal expected_node_keys, node_keys
  end

  def test_it_can_find_words
  end

end

#STUPID SHIT BELOW
  # def test_it_can_insert_two_totally_different_words
  #   c = CompleteMe.new
  #   c.insert("pi")
  #   c.insert("at")
  #   expected_node_keys = ["p", "i", "a", "t"]
  #   node_keys = []
  #   node = c.root
  #   node.each do |child|
  #     binding.pry
  #   end
  #   # while node.children.length > 0
  #   #   children = node.children
  #   #   children.each do |child|
  #   #     if child
  #   #     end
  #   #   end
  #   # end
  #   #   node.children.each_value do |value|
  #
  #
  # end

  # def test_it_can_insert_two_words
  #   skip
  #   c = CompleteMe.new
  #   c.insert("to")
  #   c.insert("too")
  #   expected_node_keys = ["t", "o", "o"]
  #   node_keys = []
  #   expected_word_count = 2
  #   node = c.root
  #   expected_flags = [false, true, true]
  #   actual_flags = {}
  #   binding.pry
  #   while node.children.keys.length >= 0
  #     node_keys << node.children.keys[0]
  #     actual_flags[node.object_id] = node.flag
  #     node = node.children[node.children.keys[0]]
  #   end
  #   assert_equal node_keys, expected_node_keys
  #   assert_equal c.count, expected_word_count
  #   assert_equal actual_flags.values, expected_flags
  # end
