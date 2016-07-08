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

  def test_a_complete_me_has_a_root
    c = CompleteMe.new
    assert c.root
  end

  def test_a_complete_me_has_a_root_that_is_a_node
    c = CompleteMe.new
    root = c.root
    class_name = root.class.name
    assert_equal "Node", class_name
  end

  def test_a_complete_me_can_update_word_count
    c = CompleteMe.new
    expected1 = 0
    actual1 = c.count
    expected2 = 1
    c.insert("pizza")
    actual2 = c.count
    expected3 = 2
    c.insert("pizzeria")
    actual3 = c.count

    assert_equal expected1, actual1, "there are no words"
    assert_equal expected2, actual2, "the only word is pizza"
    assert_equal expected3, actual3, "there are two words, pizza and pizzeria"
  end

  def test_it_can_count_words_in_an_empty_node
    c = CompleteMe.new
    node = c.root
    counter = 0
    actual = c.count(node)
    assert_equal 0, actual
  end

  def test_it_actually_counts_words
    c = CompleteMe.new
    c.insert("pizza")
    assert_equal 1, c.count
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
    c = CompleteMe.new
    c.insert("pizza")
    c.insert("pizzeria")
    assert_equal 2, c.count
  end

  def test_it_can_suggest_words
    c = CompleteMe.new
    c.insert("pizza")
    c.insert("pizzeria")
    actual = c.suggest("piz")
    assert_equal ["pizza", "pizzeria"], actual
  end

  def test_it_can_populate_from_new_line_separated_list
    c = CompleteMe.new
    c.populate("pizza\npizzeria")
    expected_count = 2
    actual_count = c.count
    expected_suggest = ["pizza", "pizzeria"]
    actual_suggest = c.suggest("piz")
    assert_equal expected_count, actual_count
    assert_equal expected_suggest, actual_suggest
  end

  def test_it_can_find_weight
    c = CompleteMe.new
    words = ["pi", "pize", "pizz", "pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)
    c.select("piz", "pizzeria")
    #binding.pry
    actual1 = c.find_weight("piz", "pizzeria")
    expected1 = 1
    c.select("piz", "pizzeria")
    actual2 = c.find_weight("piz", "pizzeria")
    expected2 = 2
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizza")
    actual3 = c.find_weight("piz", "pizzeria")
    expected3 = 4
    actual4 = c.find_weight("piz", "pizza")
    expected4 = 1
    assert_equal expected1, actual1
    assert_equal expected2, actual2
    assert_equal expected3, actual3
    assert_equal expected4, actual4
  end

  def test_it_can_order_suggestions_by_weight
    c = CompleteMe.new
    c.populate("pizza\npizzeria")
    prefix = "piz"
    c.select(prefix, "pizzeria")
    suggestions = c.suggest(prefix)
    actual = c.order_suggestions_by_weight(suggestions, prefix)
    expected = ["pizzeria", "pizza"]
    assert_equal expected, actual
  end

  def test_it_can_select
    c = CompleteMe.new
    c.populate("pizza\npizzeria")
    c.select("piz", "pizzeria")
    actual = c.suggest("piz")
    expected = ["pizzeria", "pizza"]
    assert_equal expected, actual
  end

  def test_it_suggests_correctly_for_piz
    c = CompleteMe.new
    words = ["pizza", "pizzeria", "pizzicato", "pizzle", "pize"].join("\n")
    c.populate(words)
    actual = c.suggest("piz")
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
    assert_equal expected, actual
  end

  def test_it_can_track_weight_specific_to_substring_selection
    c = CompleteMe.new
    words = ["pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)

    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")

    c.select("pi", "pizza")
    c.select("pi", "pizza")
    c.select("pi", "pizzicato")

    actual1 = c.suggest("piz")
    expected1 = ["pizzeria", "pizza", "pizzicato"]
    actual2 = c.suggest("pi")
    expected2 = ["pizza", "pizzicato","pizzeria"]

    assert_equal expected1, actual1
    assert_equal expected2, actual2

  end

  def test_it_orders_alphabetically_when_weight_is_equal
    c = CompleteMe.new
    words = ["pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)

    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")

    c.select("piz", "pizza")
    c.select("piz", "pizza")
    c.select("piz", "pizza")

    actual_weight1 = c.find_weight("piz", "pizzeria")
    actual_weight2 = c.find_weight("piz", "pizza")
    actual_suggestion = c.suggest("piz")

    expected_weight1 = 3
    expected_weight2 = 3
    expected_suggestion = ["pizza", "pizzeria", "pizzicato"]

  end

  def test_weight_takes_precedence_over_alpha_in_sort
    c = CompleteMe.new
    words = ["pi", "pize", "pizz", "pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)
    prefix = "piz"
    c.select(prefix, "pizzeria")
    weight = c.find_weight(prefix, "pizzeria")
    suggestions = c.suggest(prefix)
    #binding.pry
    actual = c.order_suggestions_by_weight(suggestions, prefix)
    expected = ["pizzeria", "pize", "pizz", "pizza", "pizzicato"]
    assert_equal expected, actual
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
