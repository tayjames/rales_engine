class Api::V1::InvoiceItems::FindController < ApplicationController
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(find_params(params)))
  end

  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :quantity, :unit_price)
  end
end
