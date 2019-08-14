class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :id, :created_at, :updated_at

  has_many :items
  has_many :invoices
end
