require_relative 'node' #do I need this?
require_relative 'trie'
require 'pry'

class CompleteMe
  attr_accessor :trie

  def initialize
    @trie = Trie.new
  end

  def suggest(prefix)
    suggestions = []
    node = @trie.root
    prefix.each_char do |letter|
      return nil if !node.children.has_key?(letter)
      node = node.children[letter]
    end
    find_all_the_words(node, prefix, suggestions)
    suggestions = order_suggestions_by_weight(suggestions, prefix)
    return suggestions
  end

  def order_suggestions_by_weight(suggestions, prefix)
    weights_words = suggestions.map do |suggestion|
      [suggestion, find_weight(prefix, suggestion)]
    end
    alphabetical_weights_words = weights_words.sort {
      |weight_word_1, weight_word_2|
      weight_word_1[0] <=> weight_word_2[0]
    }
    weighted_weights_words = alphabetical_weights_words.sort {
      |weight_word_1, weight_word_2|
      weight_word_2[1] <=> weight_word_1[1]
    }
    return weighted_weights_words.map do |weight_word|
      weight_word[0]
    end
  end

  def find_all_the_words(node, prefix, suggestions)
    suggestions << prefix if node.flag
    if node.has_children?
      node.children.keys.each do |letter|
        node_prefix = prefix
        node_prefix += letter
        child_node = node.children[letter]
        find_all_the_words(child_node, node_prefix, suggestions)
      end
    end
    return suggestions
  end

  def populate(string)
    words = string.split("\n")
    words.each do |word|
      @trie.insert(word)
    end
    return
  end

  def select(prefix, selection)
    node = @trie.root
    add_weight(node, prefix, selection)
  end

  def add_weight(node, prefix, selection)
    letter = selection[0]
    return nil if !node.children.has_key?(letter)
    child_node = node.children[letter]
    if selection.length > 1
      new_selection = selection[1..-1]
      add_weight(child_node, prefix, new_selection)
    else
      node_weight = child_node.weight
      if node_weight.has_key?(prefix)
        node_weight[prefix] += 1
      else
        node_weight[prefix] = 1
      end
    end
  end

  def find_weight(prefix, selection, node=@trie.root)
    if found_word_match?(node, selection)
      return node.weight[prefix] ? node.weight[prefix] : 0
    end
    letter = selection[0]
    return nil if !node.children.has_key?(letter)
    child_node = node.children[letter]
    find_weight(prefix, selection[1..-1], child_node)
  end

  def found_word_match?(node, selection)
    node.flag && selection.length == 0
  end

end
