require 'rails_helper'

describe "Invoice API" do
  it "sends a list of invoices" do
    merchant = create(:merchant)
    customer = create(:customer)
    create_list(:invoice, 100, merchant: merchant, customer: customer)

    get '/api/v1/invoices'
    expect(response).to be_successful

    invoices = JSON.parse(response.body)
    expect(invoices["data"].count).to eq(100)
  end

  it "can get one invoice by its id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)

    get "/api/v1/invoices/#{invoice.id}"

    show_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(show_invoice["data"]["attributes"]["id"]).to eq(invoice.id)
  end

  it "can find an invoice by an attribute" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)

    get "/api/v1/invoices/find?status=#{invoice.status}"

    found_invoice = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice.status).to eq(found_invoice["data"]["attributes"]["status"])
  end

  xit "can find all invoices that match for the given querey" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_2)

    get "/api/v1/invoices/find_all?merchant_id=#{merchant_2.id}"

    invoices = JSON.parse(response.body)
    # binding.pry
    expect(response).to be_successful
    expect(invoices["data"].count).to eq(2)
  end

  it "can return a random invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    create_list(:invoice, 10, merchant: merchant, customer: customer)

    get "/api/v1/invoices/random"
    expect(response).to be_successful
    random_invoice_1 = JSON.parse(response.body)

    get "/api/v1/invoices/random"
    expect(response).to be_successful
    random_invoice_2 = JSON.parse(response.body)

    expect(random_invoice_1["data"]["id"]).to_not eq(random_invoice_2)
  end

  it "can return a collection of associated transactions" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)

    get "/api/v1/invoices/#{invoice_1.id}/transactions"

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].first["id"]).to eq(transaction_1.id.to_s)
    expect(transactions["data"].second["id"]).to eq(transaction_2.id.to_s)
    expect(transactions["data"].third["id"]).to eq(transaction_3.id.to_s)
  end

  it "returns a collection of associated invoice items" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1)
    invoice_item_2 = create(:invoice_item, item: item_1, invoice: invoice_1)
    invoice_item_3 = create(:invoice_item, item: item_1, invoice: invoice_1)

    get "/api/v1/invoices/#{invoice_1.id}/invoice_items"

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
# binding.pry
    expect(invoice_items["data"].first["id"]).to eq(invoice_item_1.id.to_s)
    expect(invoice_items["data"].second["id"]).to eq(invoice_item_2.id.to_s)
    expect(invoice_items["data"].third["id"]).to eq(invoice_item_3.id.to_s)
  end

  it "returns a collection of associated items" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1)
    invoice_item_2 = create(:invoice_item, item: item_1, invoice: invoice_1)
    invoice_item_3 = create(:invoice_item, item: item_1, invoice: invoice_1)

    get "/api/v1/invoices/#{invoice_1.id}/items"
    expect(response).to be_successful
    # binding.pry

    items = JSON.parse(response.body)
    expect(items["data"].first["id"]).to eq(item_1.id.to_s)
  end

  it "return the associated customer" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2)

    get "/api/v1/invoices/#{invoice_1.id}/customer"
    expect(response).to be_successful
    cliente_1 = JSON.parse(response.body)
    expect(cliente_1["data"]["id"]).to eq(customer_1.id.to_s)

    get "/api/v1/invoices/#{invoice_1.id}/customer"
    expect(response).to be_successful
    cliente_2 = JSON.parse(response.body)
    expect(cliente_2["data"]["id"]).to eq(customer_1.id.to_s)

    get "/api/v1/invoices/#{invoice_2.id}/customer"
    expect(response).to be_successful
    cliente_3 = JSON.parse(response.body)
    expect(cliente_3["data"]["id"]).to eq(customer_2.id.to_s)
  end

  it "returns the associated merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2)

    get "/api/v1/invoices/#{invoice_1.id}/merchant"
    expect(response).to be_successful
    merch_1 = JSON.parse(response.body)
    expect(merch_1["data"]["id"]).to eq(merchant_1.id.to_s)

    get "/api/v1/invoices/#{invoice_2.id}/merchant"
    expect(response).to be_successful
    merch_2 = JSON.parse(response.body)
    expect(merch_2["data"]["id"]).to eq(merchant_2.id.to_s)
  end
end
