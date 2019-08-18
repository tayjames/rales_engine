class Api::V1::Transactions::FindController < ApplicationController
  def show
    render json: TransactionSerializer.new(Transaction.find_by(find_params(params)))
  end

  def index
    render json: TransactionSerializer.new(Transaction.where(find_params(params)))
  end

  private

  def find_params(params)
    params.permit(:id, :credit_card_number, :credit_card_expiration_date, :result)
  end
end
