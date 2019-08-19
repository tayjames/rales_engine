require 'rails_helper'

RSpec.describe Merchant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe "Validations" do
    it {should validate_presence_of :name}
  end

  describe "Class Methods" do
    describe "Returns the top x merchants ranked by total revenue" do
      it ".most_revenue" do
        merchant_1 = create(:merchant, name: "Jori")
        merchant_2 = create(:merchant, name: "Sarah")
        merchant_3 = create(:merchant, name: "Aurie")
        merchant_4 = create(:merchant, name: "Jake")

        customer = create(:customer)

        item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
        invoice_1 = create(:invoice, customer: customer, merchant: merchant_1)
        create(:transaction, invoice: invoice_1, result: "success")
        invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1000)

        item_2 = create(:item, merchant: merchant_2, unit_price: 500)
        invoice_2 = create(:invoice, customer: customer, merchant: merchant_2)
        create(:transaction, invoice: invoice_2, result: "success")
        invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 500)

        item_3 = create(:item, merchant: merchant_3, unit_price: 250)
        invoice_3 = create(:invoice, customer: customer, merchant: merchant_3)
        create(:transaction, invoice: invoice_3, result: "success")
        invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 1, unit_price: 250)

        item_4 = create(:item, merchant: merchant_4, unit_price: 125)
        invoice_4 = create(:invoice, customer: customer, merchant: merchant_4)
        create(:transaction, invoice: invoice_4, result: "success")
        invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_4, quantity: 1, unit_price: 250)

        expect(Merchant.most_revenue(3).first).to eq(merchant_1)
        expect(Merchant.most_revenue(3).second).to eq(merchant_2)
        expect(Merchant.most_revenue(3).third).to eq(merchant_3)
      end
    end

    describe "returns the top x merchants ranked by total number of items sold" do
      it ".most_items" do
        merchant_1 = create(:merchant, name: "Jori")
        merchant_2 = create(:merchant, name: "Sarah")
        merchant_3 = create(:merchant, name: "Aurie")
        merchant_4 = create(:merchant, name: "Jake")

        customer = create(:customer)

        item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
        invoice_1 = create(:invoice, customer: customer, merchant: merchant_1)
        create(:transaction, invoice: invoice_1, result: "success")
        invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 1000)

        item_2 = create(:item, merchant: merchant_2, unit_price: 500)
        invoice_2 = create(:invoice, customer: customer, merchant: merchant_2)
        create(:transaction, invoice: invoice_2, result: "success")
        invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 16, unit_price: 500)

        item_3 = create(:item, merchant: merchant_3, unit_price: 250)
        invoice_3 = create(:invoice, customer: customer, merchant: merchant_3)
        create(:transaction, invoice: invoice_3, result: "success")
        invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 23, unit_price: 250)

        item_4 = create(:item, merchant: merchant_4, unit_price: 125)
        invoice_4 = create(:invoice, customer: customer, merchant: merchant_4)
        create(:transaction, invoice: invoice_4, result: "success")
        invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_4, quantity: 1, unit_price: 125)

        expect(Merchant.most_items(3).first).to eq(merchant_3)
        expect(Merchant.most_items(3).second).to eq(merchant_2)
        expect(Merchant.most_items(3).third).to eq(merchant_1)
      end
    end

    describe "returns the total revenue for date x across all merchants" do
      it ".revenue_by_date" do
        merchant_1 = create(:merchant, name: "Jori")
        merchant_2 = create(:merchant, name: "Sarah")
        merchant_3 = create(:merchant, name: "Aurie")
        merchant_4 = create(:merchant, name: "Jake")

        customer = create(:customer)

        item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
        invoice_1 = create(:invoice, customer: customer, merchant: merchant_1)
        create(:transaction, invoice: invoice_1, result: "success")
        invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1000)

        item_2 = create(:item, merchant: merchant_2, unit_price: 500)
        invoice_2 = create(:invoice, customer: customer, merchant: merchant_2)
        create(:transaction, invoice: invoice_2, result: "success")
        invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 500)

        item_3 = create(:item, merchant: merchant_3, unit_price: 250)
        invoice_3 = create(:invoice, customer: customer, merchant: merchant_3)
        create(:transaction, invoice: invoice_3, result: "success")
        invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 1, unit_price: 250)

        item_4 = create(:item, merchant: merchant_4, unit_price: 125)
        invoice_4 = create(:invoice, customer: customer, merchant: merchant_4)
        create(:transaction, invoice: invoice_4, result: "success")
        invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_4, quantity: 1, unit_price: 125)

        expect(Merchant.revenue_by_date("2019-08-17")).to eq(1875)
      end
    end
  end

  describe "Instance methods" do
    describe "returns the total revenue for that merchant across successful transactions"
      it "total_revenue" do
        merchant_1 = create(:merchant, name: "Jori")
        customer = create(:customer)

        item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
        item_5 = create(:item, merchant: merchant_1, unit_price: 1000)

        invoice_1 = create(:invoice, customer: customer, merchant: merchant_1)
        invoice_5 = create(:invoice, customer: customer, merchant: merchant_1)

        transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
        transaction_5 = create(:transaction, invoice: invoice_5, result: "success")

        invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1000)
        invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_5, quantity: 4, unit_price: 1000)

        expect(merchant_1.revenue). to eq(5000)
      end
    end
end
