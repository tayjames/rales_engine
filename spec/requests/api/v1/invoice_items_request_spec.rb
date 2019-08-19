require 'rails_helper'

describe "InvoiceItem API" do
  it "sends a list of invoice_items" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    create_list(:invoice_item, 100, item: item, invoice: invoice)

    get '/api/v1/invoice_items'
    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].count).to eq(100)
  end

  it "can get one invoice_item by its id" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}"

    show_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(show_invoice_item["data"]["attributes"]["id"]).to eq(invoice_item.id)
  end

  it "can find an invoice_item by an attribute" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    invoice_item = create(:invoice_item, item: item, invoice: invoice, quantity: 14, unit_price: 1000)

    get "/api/v1/invoice_items/find?quantity=14"

    found_invoice_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_item.quantity).to eq(found_invoice_item["data"]["attributes"]["quantity"])

    get "/api/v1/invoice_items/find?unit_price=1000"

    found_invoice_item_2 = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_item.unit_price).to eq(found_invoice_item_2["data"]["attributes"]["unit_price"])
  end

  it "can find all invoice_items that match for the given querey" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    invoice_item_1 = create(:invoice_item, item: item, invoice: invoice, quantity: 14, unit_price: 1000)
    invoice_item_2 = create(:invoice_item, item: item, invoice: invoice, quantity: 14, unit_price: 1000)
    invoice_item_2 = create(:invoice_item, item: item, invoice: invoice, quantity: 13, unit_price: 1000)

    get "/api/v1/invoice_items/find_all?quantity=14"

    quantity = JSON.parse(response.body)
    expect(response).to be_successful
    expect(quantity["data"].count).to eq(2)
  end

  it "can return a random invoice_item" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    create_list(:invoice_item, 10, item: item, invoice: invoice)

    get "/api/v1/invoice_items/random"
    expect(response).to be_successful
    random_1 = JSON.parse(response.body)

    get "/api/v1/invoice_items/random"
    expect(response).to be_successful
    random_2 = JSON.parse(response.body)

    expect(random_1["data"]["id"]).to_not eq(random_2)
  end

  it "returns the associated invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)

    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    expect(response).to be_successful
    inv = JSON.parse(response.body)
    # binding.pry
    expect(inv["data"].first.last).to eq(invoice.id.to_s)
  end

  it "returns the associated item" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)

    # binding.pry

    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(inv["data"].first.last).to eq(item.id.to_s)
  end


end
