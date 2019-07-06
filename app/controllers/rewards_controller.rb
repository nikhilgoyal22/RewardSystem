class RewardsController < ApplicationController
  def index
    data = params[:file].read.split("\n").map.with_index do |row, index|
      line = row.strip.split(' ')
      line[3] == 'accepts' ? {node: line[2], accepts: true} : {node: line[4], parent: line[2]}
    end
    
    render json: {data: process_and_calculate(data)}
  end

  private

  def process_and_calculate(data)
    @tree = Tree.new
    @tree.build(data)
    @tree.calculate
  end
end
