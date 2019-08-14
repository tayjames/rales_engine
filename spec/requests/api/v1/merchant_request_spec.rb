require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 100)
    get '/api/v1/merchants'
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(100)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id.to_s)
  end

  it "can find a merchant by an attribute" do
    merchant = create(:merchant)
    get "/api/v1/merchants/find?name=#{merchant.name}"

    jori = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant.name).to eq(jori["data"]["attributes"]["name"])
  end

  it "can find all merchants that match for the given querey" do
    jori = create(:merchant, name: "Name", created_at: "2019-08-13T00:00:00.000Z")
    seijin = create(:merchant, name: "Name", created_at: "2019-08-13T00:00:00.000Z")
    tay = create(:merchant, name: "Nombre")

    get "/api/v1/merchants/find_all?name=Name"

    merchants = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchants["data"].count).to eq(2)

    get "/api/v1/merchants/find_all?created_at=2019-08-13T00:00:00.000Z"

    merchants_created = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchants["data"].count).to eq(2)
  end

  it "can return a random merchant" do
    create_list(:merchant, 10)

    get "/api/v1/merchants/random"
    expect(response).to be_successful

    random_merchant_1 = JSON.parse(response.body)

    get "/api/v1/merchants/random"

    random_merchant_2 = JSON.parse(response.body)
    expect(random_merchant_1["data"]["id"]).to_not eq(random_merchant_2["id"])
  end
end
