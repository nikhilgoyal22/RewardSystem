class Tree
  attr_accessor :root, :node_map, :calculation

  ROOT_NAME = 'system'

  def initialize
    @root = Node.new(ROOT_NAME)
    @root.tree = self
    @node_map = {}
    @calculation = {}
    @node_map[ROOT_NAME] = @root
  end

  def build(data)
    data.each do |line|
      line[:accepts] ? update_node(line[:node]) : add_node(line[:node], line[:parent])
    end
  end

  def calculate
    root.children.map{|node| node.calculate }
    calculation
  end

  private

  def add_node(node, parent = ROOT_NAME)
    return unless node_map[node].nil?
    parent_node = node_map[parent] ||= add_node(parent)
    added_node = node_map[node] = Node.new(node, parent_node)
    parent_node.children << added_node
    added_node
  end

  def update_node(node)
    current_node = node_map[node]
    #add error if doesnt exist in node_map or parent is system
    current_node.accepted = true
    node_map[node] = current_node
  end
end