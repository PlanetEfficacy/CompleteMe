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

  def test_a_CompleteMe_can_insert_a_word
    c = CompleteMe.new
    assert c.insert("Pizza")
  end

  def test_a_CompleteMe_can_update_word_count
    c = CompleteMe.new
    c.insert("pizza")
    assert_equal 1, c.count
  end

  def test_can_see_root_node
    c = CompleteMe.new
    c.insert("pizza")
    assert_instance_of Node, c.root

  end

  def test_insert_can_split_word
    c = CompleteMe.new
    assert_instance_of Array, c.insert("pizza")
  end

  def test_can_iterate_through_each_letter
    c = CompleteMe.new
    string = "pizza"
    length = string.length
    assert_equal length, c.insert("pizza").length
  end

  def test_flag_true_on_final_node_after_insert_word
    c = CompleteMe.new
    string = "pizza"
    pizza_array = string.split
    c.insert(string)
    node = c.root
    check_flag = false
    pizza_array.each do |letter|
      node = node.children[letter]
      check_flag = node.flag
    end
    assert_equal check_flag, true
  end




end
