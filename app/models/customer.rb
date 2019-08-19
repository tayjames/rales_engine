class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :first_name
  validates_presence_of :last_name

  def favorite_merchant(customer_id)
    Invoice.joins(:transactions, :merchant)
    .select("merchants.*, COUNT(invoices.merchant_id) AS succ_trans")
    .merge(Transaction.successful)
    .where(invoices: {customer_id: customer_id})
    .group("merchants.id")
    .order("succ_trans DESC")
    .limit(1)
  end
end
