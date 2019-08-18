class Api::V1::Invoices::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Invoice.find(params["id"]).merchant)
  end
end
