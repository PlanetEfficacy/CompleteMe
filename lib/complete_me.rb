require_relative 'node'
require 'pry'

class CompleteMe
  attr_accessor :root
  attr_reader :count

  def initialize
    @root = Node.new
    @count = 0
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
    return suggestions if node.children.empty?
    node.children.keys.each do |char|
        prefix += char
        node = node.children[char]
        find_all_the_words(node, prefix, suggestions)
    end
  end

end
