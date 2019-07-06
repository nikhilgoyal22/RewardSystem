# frozen_string_literal: true

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
    root.children.map(&:calculate)
    calculation
  end

  private

  def add_node(node, parent = ROOT_NAME)
    parent_node = node_map[parent] ||= add_node(parent)
    existing_node = validate_recommends(node_map[node], parent_node)
    return if @line_errors.present?

    insert_node(node, parent_node) if existing_node.nil?
  end

  def insert_node(node, parent_node)
    node_map[node] = Node.new(node, parent_node)
  end

  def update_node(node)
    current_node = node_map[node]
    validate_accept(current_node)
    return if @line_errors.present? || current_node.accepted

    accept_node(current_node)
  end

  def accept_node(node)
    node.accepted = true
    node.parent.children << node
    node_map[node] = node
  end

  def validate_recommends(node, parent)
    @line_errors = []
    add_error(@index, "Customer #{node.name} already exists") if node&.accepted
    add_error(@index, "Customer #{parent.name} is not accepted yet") unless parent&.accepted
    node
  end

  # add error if doesnt exist in node_map or parent is system node
  def validate_accept(node)
    @line_errors = []
    add_error(@index, 'No invitation exists to accept') if node.nil?
    add_error(@index, "Customer #{node.name} already exists") if node&.parent&.root?
  end

  def add_error(index, message)
    error = { line_num: index + 1, message: message }
    errors << error
    @line_errors << error
  end
end
