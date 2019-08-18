class Api::V1::Customers::FindController < ApplicationController
  def show
    render json: CustomerSerializer.new(Customer.find_by(find_params(params)))
  end

  def index
    render json: CustomerSerializer.new(Customer.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :first_name, :last_name)
  end
end
