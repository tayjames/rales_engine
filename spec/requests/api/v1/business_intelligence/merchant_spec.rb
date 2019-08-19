require "rails_helper"

describe "Merchant Business Intelligence" do
  it "Returns the total revenue for that merchant across successful transactions" do
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

    get "/api/v1/merchants/#{merchant_1.id}/revenue"

    expect(response).to be_successful

    merchant_rev = JSON.parse(response.body)
    # binding.pry
    expect(merchant_rev["data"]["attributes"]["revenue"]).to eq("50.00")
  end
end
