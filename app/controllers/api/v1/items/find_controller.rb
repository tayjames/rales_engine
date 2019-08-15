class Api::V1::Items::FindController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find_by(find_params(params)))
  end

  def index
    render json: ItemSerializer.new(Item.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at)
  end
end
