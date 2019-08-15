require "rails_helper"

describe "Transaction API" do
  it "sends a list of transactions" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    create_list(:transaction, 100, invoice: invoice)

    get '/api/v1/transactions'
    expect(response).to be_successful

    transactions = JSON.parse(response.body)
    expect(transactions["data"].count).to eq(100)
  end

  it "can get one transaction by its id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    transaction = create(:transaction, invoice: invoice)

    get "/api/v1/transactions/#{transaction.id}"

    show_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(show_transaction["data"]["attributes"]["id"]).to eq(transaction.id)
  end
end
