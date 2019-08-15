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
end
