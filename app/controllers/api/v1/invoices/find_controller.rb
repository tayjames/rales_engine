class Api::V1::Invoices::FindController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Invoice.find_by(find_params(params)))
  end

  def index
    render json: InvoiceSerializer.new(Invoice.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :status, :created_at, :updated_at)
  end
end
