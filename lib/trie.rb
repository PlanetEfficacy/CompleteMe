require_relative 'node'

class Trie

  attr_accessor :root

  def initialize
    @root = Node.new
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
    return
  end

  def count(node=@root)
    word_count = 0
    word_count += 1 if node.flag
    if node.has_children?
      node.children.keys.each do |letter|
        child_node = node.children[letter]
        word_count += count(child_node)
      end
    end
    return word_count
  end

  def delete(word)
  end

end
