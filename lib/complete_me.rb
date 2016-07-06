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
    something = word.split('').map do |char|
      if !node.children.has_key?(char)
        node.children[char] = Node.new
      end
      node = node.children[char]
    end
    node.flag = true
    binding.pry
    @count += 1
    something
  end

end
