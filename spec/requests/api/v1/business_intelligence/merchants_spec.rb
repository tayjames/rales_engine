require "rails_helper"

describe "Merchants Business Intelligence" do
  it "Returns the top x merchants ranked by total revenue" do
    merchant_1 = create(:merchant, name: "Jori")
    merchant_2 = create(:merchant, name: "Sarah")
    merchant_3 = create(:merchant, name: "Aurie")
    merchant_4 = create(:merchant, name: "Jake")

    customer = create(:customer)

    item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
    item_5 = create(:item, merchant: merchant_1, unit_price: 999)
    invoice_1 = create(:invoice, customer: customer, merchant: merchant_1)
    invoice_5 = create(:invoice, customer: customer, merchant: merchant_1)

    transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
    transaction_5 = create(:transaction, invoice: invoice_5, result: "success")

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1000)
    invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_5, quantity: 4, unit_price: 1000)

    item_2 = create(:item, merchant: merchant_2, unit_price: 500)
    invoice_2 = create(:invoice, customer: customer, merchant: merchant_2)
    transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 500)

    item_3 = create(:item, merchant: merchant_3, unit_price: 250)
    invoice_3 = create(:invoice, customer: customer, merchant: merchant_3)
    transaction_3 = create(:transaction, invoice: invoice_3, result: "success")
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 1, unit_price: 250)

    item_4 = create(:item, merchant: merchant_4, unit_price: 125)
    invoice_4 = create(:invoice, customer: customer, merchant: merchant_4)
    transaction_4 = create(:transaction, invoice: invoice_4, result: "success")
    invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_4, quantity: 1, unit_price: 125)
    # binding.pry
    get "/api/v1/merchants/most_revenue?quantity=3"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(3)
  end

  it "returns the top x merchants ranked by total number of items sold" do
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

    get "/api/v1/merchants/most_items?quantity=3"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(3)
  end

  it "returns the total revenue for date x across all merchants" do
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

    get "/api/v1/merchants/revenue?date=2019-08-17"

    expect(response).to be_successful

    # binding.pry
    merchant_rev = JSON.parse(response.body)
    expect(merchant_rev["data"]["attributes"]["revenue"]).to eq("18.75")
  end
end
