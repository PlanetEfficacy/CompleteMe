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
    word.each_char.map do |char|
      if !node.children.has_key?(char)
        node.children[char] = Node.new
      end
      node = node.children[char]
    end
    node.flag = true
  end

  def suggest(prefix)
    suggestions = []
    node = @root
    prefix.each_char do |char|
      if !node.children.has_key?(char)
        return nil
      end
      node = node.children[char]
    end
    find_all_the_words(node, prefix, suggestions)
    return suggestions
  end

  def find_all_the_words(node, prefix, suggestions)
    suggestions << prefix if node.flag
    if !node.children.empty?
      node.children.keys.each do |char|
        this_nodes_prefix = prefix
        this_nodes_prefix += char
        child_node = node.children[char]
        find_all_the_words(child_node, this_nodes_prefix, suggestions)
      end
    end
    return suggestions
  end

end

#STUPID SHIT
# def traverse(node, proc, container)
#   return if node.children.empty?
#   node.children.keys.each do |letter|
#     proc.call(node, letter, container) if proc
#     node = node.children[letter]
#     traverse(node)
#   end
# end

# def count_words_in_this_node(node, counter)
#   counter += 1 if node.flag
#   if !node.children.empty?
#     node.children.keys.each do |letter|
#       #child_word_counter = counter
#       child_node = node.children[letter]
#       counter += count_words_in_this_node(child_node, counter)
#     end
#   end
#   return counter
# end
#
# def count
#   node = @root
#   counter = @counter
#   binding.pry
#   new_counter = count_words_in_this_node(node, counter)
# end
