require 'rails_helper'

describe "Customer API" do
  it "sends a list of customers" do
    create_list(:customer, 100)
    get '/api/v1/customers'
    expect(response).to be_successful

    customers = JSON.parse(response.body)
    expect(customers["data"].count).to eq(100)
  end

  it "can get one customer by its id" do
    id = create(:customer).id
    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(id.to_s)
  end

  it "can find a customer by an attribute" do
    customer = create(:customer)
    get "/api/v1/customers/find?name=#{customer.first_name}"
  end

  it "can find all merchants that match for the given querey" do
    customer_1 = create(:customer, first_name: "Tay", last_name: "Jimenez")
    customer_2 = create(:customer, first_name: "Julie", last_name: "Jimenez")
    customer_2 = create(:customer, first_name: "Tay", last_name: "DeHerrera")
    get "/api/v1/customers/find_all?last_name=Jimenez"

    customers = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customers["data"].count).to eq(2)

    get "/api/v1/customers/find_all?first_name=Tay"

    clientes = JSON.parse(response.body)
    expect(response).to be_successful
    expect(clientes["data"].count).to eq(2)
  end

  it "can return a random customer" do
    create_list(:customer, 10)

    get "/api/v1/customers/random"
    expect(response).to be_successful

    random_customer_1 = JSON.parse(response.body)

    get "/api/v1/customers/random"

    random_customer_2 = JSON.parse(response.body)
    expect(random_customer_1["data"]["id"]).to_not eq(random_customer_2["id"])
  end

  it "returns a collection of associated invoices" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)

    get "/api/v1/customers/#{customer_1.id}/transactions"
    expect(response).to be_successful

    transaction = JSON.parse(response.body) # => 
      # binding.pry
    expect(transaction["data"].count).to eq(3)
    expect(transaction["data"].first["id"]).to eq(transaction_1.id.to_s)
    expect(transaction["data"].second["id"]).to eq(transaction_2.id.to_s)
    expect(transaction["data"].third["id"]).to eq(transaction_3.id.to_s)
  end
end
