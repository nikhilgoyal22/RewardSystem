class Tree
  attr_accessor :root, :node_map, :calculation, :errors

  ROOT_NAME = 'system'

  def initialize
    @root = Node.new(ROOT_NAME)
    @root.tree = self
    @node_map = {}
    @calculation = {}
    @errors = []
    @node_map[ROOT_NAME] = @root
  end

  def build(data)
    data.each do |line|
      @index = line[:index]
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
    validate_accept(current_node)
    return if errors.present? || current_node.accepted
    current_node.accepted = true
    node_map[node] = current_node
  end

  #add error if doesnt exist in node_map or parent is system node
  def validate_accept(node)
    errors << {line_num: @index + 1, msg: 'No invitation exists to accept'} if node.nil?
    errors << {line_num: @index + 1, msg: 'User already exists'} if node&.parent&.is_root?
  end
end