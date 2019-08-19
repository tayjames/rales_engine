class Api::V1::InvoiceItems::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(InvoiceItem.find(params["id"]).item)
  end
end
