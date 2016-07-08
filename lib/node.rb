class Node

  attr_accessor :flag,
                :children,
                :weight

  def initialize
    @flag = false
    @children = {}
    @weight = {}
  end

  def has_children?
    !@children.empty?
  end

  def does_not_have_children?
    @children.empty?
  end

end
