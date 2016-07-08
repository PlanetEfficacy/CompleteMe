require_relative 'test_helper'
require_relative '../lib/trie'

class TrieTest < Minitest::Test

  def test_it_can_insert_word
    t = Trie.new
    t.insert("pizza")
    expected_node_keys = ["p", "i", "z", "z", "a"]
    node_keys = []
    node = t.root

    while node.children.keys.length > 0
      node_keys << node.children.keys[0]
      node = node.children[node.children.keys[0]]
    end

    assert_equal node_keys, expected_node_keys
  end

  def test_it_can_count_words
    t = Trie.new
    expected1 = 0
    expected2 = 1
    expected3 = 2

    actual1 = t.count
    t.insert("pizza")
    actual2 = t.count
    t.insert("pizzeria")
    actual3 = t.count

    assert_equal expected1, actual1, "there are no words"
    assert_equal expected2, actual2, "the only word is pizza"
    assert_equal expected3, actual3, "there are two words, pizza and pizzeria"
  end

  def test_it_can_insert_words
    t = Trie.new
    t.insert("pizza")
    t.insert("pizzeria")

    assert_equal 2, t.count
  end

  def test_it_can_count_words_in_an_empty_node
    t = Trie.new
    node = t.root
    counter = 0

    actual = t.count(node)

    assert_equal counter, actual
  end

  def test_it_actually_counts_words
    t = Trie.new
    expected1 = 0
    expected2 = 1
    expected3 = 4

    count1 = t.count
    t.insert("pizza")
    count2 = t.count
    t.insert("avacado")
    t.insert("cup")
    t.insert("pipe")
    count3 = t.count

    assert_equal expected1, count1
    assert_equal expected2, count2
    assert_equal expected3, count3
  end

end
