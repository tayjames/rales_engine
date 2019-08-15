class Api::V1::Items::RandomController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.order("random()").limit(1).first)
  end
end
