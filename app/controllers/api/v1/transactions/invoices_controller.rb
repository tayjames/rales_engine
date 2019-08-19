class Api::V1::Transactions::InvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Transaction.find(params[:id]).invoice)
  end
end
