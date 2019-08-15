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
    binding.pry
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
end
