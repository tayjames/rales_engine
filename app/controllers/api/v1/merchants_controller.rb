class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
