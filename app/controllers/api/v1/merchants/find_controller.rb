class Api::V1::Merchants::FindController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.find_by(find_params(params)))
  end

  def index
    render json: MerchantSerializer.new(Merchant.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
