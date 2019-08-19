class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  validates_presence_of :name

  def self.most_revenue(quantity)
    joins(:invoices)
    .joins("Join invoice_items ON invoices.id = invoice_items.invoice_id")
    .joins("Join transactions ON invoices.id = transactions.invoice_id")
    .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .where("transactions.result = ?", "success")
    .group(:id).order("revenue desc")
    .limit(quantity)
  end

  def self.most_items(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.quantity) AS count')
    .group('merchants.id')
    .order('count DESC')
    .limit(quantity)
    .where("transactions.result = ?", 'success')
  end

  def self.revenue_by_date(date)
    Invoice
    .joins(:invoice_items, :transactions)
    .where("transactions.result=?", "success")
    .where({invoice_items:{created_at: (date.to_date.all_day)}})
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def revenue
    invoices
    .joins(:invoice_items, :transactions)
    .where("transactions.result = ?", "success")
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def fave_customer(merchant_id)
    Invoice.joins(:transactions, :customer)
    .select("customers.*, COUNT(invoices.customer_id) AS succ_trans")
    .merge(Transaction.successful)
    .where(invoices: {merchant_id: merchant_id})
    .group("customers.id")
    .order("succ_trans DESC").limit(1)
  end
end
