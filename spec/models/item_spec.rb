require 'rails_helper'

RSpec.describe Item, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  describe "Relationships" do
    it {should have_many :invoice_items}
    it {should have_many :invoices}
    it {should belong_to :merchant}
  end

  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
  end
end
