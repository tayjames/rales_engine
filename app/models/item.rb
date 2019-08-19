class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def most_revenue(quantity)
    Item.joins(invoice_items: [invoice: :transactions])
    .where("transactions.result = ?", "success")
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order("revenue desc")
    .limit(quantity)
  end
end
