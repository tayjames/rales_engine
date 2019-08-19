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

  it "can find a transaction by an attribute" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    transaction = create(:transaction, invoice: invoice, credit_card_number: 123456789, result: "success")

    get "/api/v1/transactions/find?credit_card_number=#{transaction.credit_card_number}"

    ccn = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction.credit_card_number).to eq(ccn["data"]["attributes"]["credit_card_number"])
  end

  it "can find all transactions that match for the given querey" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    transaction_1 = create(:transaction, invoice: invoice, credit_card_number: 123456789, result: "success")
    transaction_2 = create(:transaction, invoice: invoice, credit_card_number: 123456789, result: "success")
    transaction_3 = create(:transaction, invoice: invoice, credit_card_number: 1234567890, result: "success")

    get "/api/v1/transactions/find_all?credit_card_number=123456789"

    transactions = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transactions["data"].count).to eq(2)
  end

  it "can return a random transaction" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    create_list(:transaction, 10, invoice: invoice)

    get "/api/v1/transactions/random"
    expect(response).to be_successful
    # binding.pry
    random_1 = JSON.parse(response.body)

    get "/api/v1/transactions/random"
    expect(response).to be_successful
    random_2 = JSON.parse(response.body)

    expect(random_1["data"]["id"]).to_not eq(random_2)
  end

  it "returns the associated invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)
    transaction = create(:transaction, invoice: invoice)

    get "/api/v1/transactions/#{transaction.id}/invoice"

    expect(response).to be_successful
    invoice_1 = JSON.parse(response.body)
    # binding.pry
    expect(invoice_1["data"]["id"]).to eq(invoice.id.to_s)
  end
end
