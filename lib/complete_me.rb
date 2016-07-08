require_relative 'node'
require 'pry'

class CompleteMe
  attr_accessor :root

  def initialize
    @root = Node.new
  end

  def count(node=@root)
    word_count = 0
    word_count += 1 if node.flag
    if !node.children.empty?
      node.children.keys.each do |letter|
        child_node = node.children[letter]
        word_count += count(child_node)
      end
    end
    return word_count
  end

  def insert(word)
    node = @root
    word.each_char.map do |letter|
      if !node.children.has_key?(letter)
        node.children[letter] = Node.new
      end
      node = node.children[letter]
    end
    node.flag = true
  end

  def suggest(prefix)
    suggestions = []
    node = @root
    prefix.each_char do |letter|
      if !node.children.has_key?(letter)
        return nil
      end
      node = node.children[letter]
    end
    find_all_the_words(node, prefix, suggestions)
    suggestions = order_suggestions_by_weight(suggestions, prefix)
    return suggestions
  end

  def order_suggestions_by_weight(suggestions, prefix)
    weights_and_suggestions = suggestions.map do |suggestion|
      [suggestion, find_weight(prefix, suggestion)]
    end

    #binding.pry
    weights_and_suggestions = weights_and_suggestions.sort {
      |weight_suggestion_pair_1, weight_suggestion_pair_2|
      weight_suggestion_pair_1[0] <=> weight_suggestion_pair_2[0]
    }
    weights_and_suggestions = weights_and_suggestions.sort {
      |weight_suggestion_pair_1, weight_suggestion_pair_2|
      weight_suggestion_pair_2[1] <=> weight_suggestion_pair_1[1]
    }


    return weights_and_suggestions.map do |weight_suggestion_pair|
      weight_suggestion_pair[0]
    end
  end

  def find_all_the_words(node, prefix, suggestions)
    suggestions << prefix if node.flag
    if !node.children.empty?
      node.children.keys.each do |letter|
        this_nodes_prefix = prefix
        this_nodes_prefix += letter
        child_node = node.children[letter]
        find_all_the_words(child_node, this_nodes_prefix, suggestions)
      end
    end
    return suggestions
  end

  def populate(string)
    words = string.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def select(prefix, selection)
    node = @root
    add_weight(node, prefix, selection)
  end

  def add_weight(node, prefix, selection)
    letter = selection[0]
    return nil if !node.children.has_key?(letter)
    child_node = node.children[letter]
    if selection.length == 1
      node_weight = child_node.weight
      if node_weight.has_key?(prefix)
        node_weight[prefix] += 1
      else
        node_weight[prefix] = 1
      end
    else
      new_selection = selection[1..-1]
      add_weight(child_node, prefix, new_selection)
    end
  end

  def find_weight(prefix, selection, node=@root)
    if node.flag && selection.length == 0
      return node.weight[prefix] ? node.weight[prefix] : 0
    end
    letter = selection[0]
    return nil if !node.children.has_key?(letter)
    child_node = node.children[letter]
    find_weight(prefix, selection[1..-1], child_node)
  end

end
