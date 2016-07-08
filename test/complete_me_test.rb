require_relative 'test_helper'
require_relative '../lib/complete_me'

class CompleteMeTest < Minitest::Test

  def test_a_complete_me_has_a_trie
    c = CompleteMe.new

    trie = c.trie
    class_name = trie.class.name

    assert_equal "Trie", class_name
  end

  def test_can_see_root_node
    c = CompleteMe.new
    t = c.trie
    t.insert("pizza")
    assert_instance_of Trie, c.trie
  end

  def test_it_knows_pizza_is_in_the_dictionary
    c = CompleteMe.new
    t = c.trie
    t.insert("pizza")
    assert_equal ["pizza"], c.suggest("pizza")
  end

  def test_it_can_suggest_word_from_prefix
    c = CompleteMe.new
    t = c.trie
    t.insert("pizza")
    assert_equal ["pizza"], c.suggest("piz")
  end

  def test_it_can_suggest_words
    c = CompleteMe.new
    t = c.trie
    t.insert("pizza")
    t.insert("pizzeria")
    t.insert("jet")
    t.insert("pipe")
    t.insert("pi")

    actual = c.suggest("piz")
    assert_equal ["pizza", "pizzeria"], actual
  end

  def test_it_can_populate_from_new_line_separated_list
    c = CompleteMe.new
    t = c.trie
    c.populate("pizza\npizzeria")
    expected_count = 2
    expected_suggest = ["pizza", "pizzeria"]

    actual_count = t.count
    actual_suggest = c.suggest("piz")

    assert_equal expected_count, actual_count
    assert_equal expected_suggest, actual_suggest
  end

  def test_it_can_find_weight
    c = CompleteMe.new
    t = c.trie
    words = ["pi", "pize", "pizz", "pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)
    expected1 = 1
    expected2 = 2
    expected3 = 4
    expected4 = 1

    c.select("piz", "pizzeria")
    actual1 = c.find_weight("piz", "pizzeria")
    c.select("piz", "pizzeria")
    actual2 = c.find_weight("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizza")
    actual3 = c.find_weight("piz", "pizzeria")
    actual4 = c.find_weight("piz", "pizza")

    assert_equal expected1, actual1
    assert_equal expected2, actual2
    assert_equal expected3, actual3
    assert_equal expected4, actual4
  end

  def test_it_can_order_suggestions_by_weight
    c = CompleteMe.new
    t = c.trie
    c.populate("pizza\npizzeria")
    prefix = "piz"
    expected = ["pizzeria", "pizza"]

    c.select(prefix, "pizzeria")
    suggestions = c.suggest(prefix)
    actual = c.order_suggestions_by_weight(suggestions, prefix)

    assert_equal expected, actual
  end

  def test_it_can_select
    c = CompleteMe.new
    t = c.trie
    c.populate("pizza\npizzeria")
    expected = ["pizzeria", "pizza"]

    c.select("piz", "pizzeria")
    actual = c.suggest("piz")

    assert_equal expected, actual
  end

  def test_it_suggests_correctly_for_piz
    c = CompleteMe.new
    t = c.trie
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
    words = ["pizza", "pizzeria", "pizzicato", "pizzle", "pize"].join("\n")
    c.populate(words)

    actual = c.suggest("piz")

    assert_equal expected, actual
  end

  def test_it_can_track_weight_specific_to_substring_selection
    c = CompleteMe.new
    t = c.trie
    expected1 = ["pizzeria", "pizza", "pizzicato"]
    expected2 = ["pizza", "pizzicato","pizzeria"]
    words = ["pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)

    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")

    c.select("pi", "pizza")
    c.select("pi", "pizza")
    c.select("pi", "pizzicato")

    actual1 = c.suggest("piz")
    actual2 = c.suggest("pi")

    assert_equal expected1, actual1
    assert_equal expected2, actual2
  end

  def test_it_orders_alphabetically_when_weight_is_equal
    c = CompleteMe.new
    t = c.trie
    words = ["pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)
    expected_weight1 = 3
    expected_weight2 = 3
    expected_suggestion = ["pizza", "pizzeria", "pizzicato"]

    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")

    c.select("piz", "pizza")
    c.select("piz", "pizza")
    c.select("piz", "pizza")

    actual_weight1 = c.find_weight("piz", "pizzeria")
    actual_weight2 = c.find_weight("piz", "pizza")
    actual_suggestion = c.suggest("piz")

    assert_equal expected_weight1, actual_weight1
    assert_equal expected_weight2, actual_weight2
    assert_equal expected_suggestion, actual_suggestion
  end

  def test_weight_takes_precedence_over_alpha_in_sort
    c = CompleteMe.new
    t = c.trie
    prefix = "piz"
    expected = ["pizzeria", "pize", "pizz", "pizza", "pizzicato"]
    words = ["pi", "pize", "pizz", "pizza", "pizzeria", "pizzicato"].join("\n")
    c.populate(words)

    c.select(prefix, "pizzeria")
    weight = c.find_weight(prefix, "pizzeria")
    suggestions = c.suggest(prefix)
    actual = c.order_suggestions_by_weight(suggestions, prefix)

    assert_equal expected, actual
  end
end
