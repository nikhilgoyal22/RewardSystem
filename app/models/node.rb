class Node
  attr_accessor :name, :points, :accepted, :parent, :children, :tree

  CHILD_REWARD_MULTIPLIER = 0.5

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @points = 0
    @accepted = parent.nil? || parent.is_root?
    @children = []
    @tree = parent&.tree
  end

  def is_root?
    name == Tree::ROOT_NAME
  end

  def calculate
    return 0 if !(accepted && children.present?)
    points = children.size + CHILD_REWARD_MULTIPLIER * children.map(&:calculate).reduce(:+)
    tree.calculation[name] = points
    points
  end
end