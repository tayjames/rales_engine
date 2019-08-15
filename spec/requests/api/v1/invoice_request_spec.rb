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
end
