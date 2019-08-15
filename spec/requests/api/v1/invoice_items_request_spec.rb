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
    invoice_item = create(:invoice_item, item: item, invoice: invoice, )

    get "/api/v1/invoice_items/#{invoice_item.id}"

    show_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(show_invoice_item["data"]["attributes"]["id"]).to eq(invoice_item.id)
  end
end
