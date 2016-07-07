require_relative 'node'
require 'pry'

class CompleteMe
  attr_accessor :root
  attr_reader :count

  def initialize
    @root = Node.new
    @count = count_words
  end

  # def traverse(node, proc, container)
  #   return if node.children.empty?
  #   node.children.keys.each do |letter|
  #     proc.call(node, letter, container) if proc
  #     node = node.children[letter]
  #     traverse(node)
  #   end
  # end

  def count_words_in_this_node(node, counter)
    return counter if node.children.empty?
    node.children.keys.each do |letter|
      counter += 1 if node.children[letter].flag
      node = node.children[letter]
      count_words_in_this_node(node, counter)
    end
  end

  def count_words
    node = @root
    counter = 0
    count_words_in_this_node(node, counter)
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
    @count += 1
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
