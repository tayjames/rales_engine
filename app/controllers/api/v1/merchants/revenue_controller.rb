class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    if params[:id] && !params[:date]
      merchant = Merchant.find(params[:id])
      render json: RevenueSerializer.new(merchant)
    elsif params[:date] && !params[:id]
      # merchant = Merchant.find(params[:id])
      revenue = Merchant.revenue_by_date(params[:date])
      render json: RevenueSerializer.new(revenue)
    end
  end
end
