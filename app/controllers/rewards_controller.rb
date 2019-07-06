# frozen_string_literal: true

class RewardsController < ApplicationController
  include Validator

  def index
    data = validate(params[:file].read.split("\n"))
    result, status = process_and_calculate(data)
    render json: result, status: status
  end

  private

  def build_tree(data)
    @tree = Tree.new
    @tree.build(data)
  end

  def process_and_calculate(data)
    build_tree(data)
    errors = validation_errors + @tree.errors
    return [{ errors: errors }, 422] if errors.present?

    [@tree.calculate, :ok]
  end
end
