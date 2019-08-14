require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 100, merchant: merchant)

    get '/api/v1/items'
    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(100)
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    get "/api/v1/items/#{item.id}"

    show_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(show_item["data"]["attributes"]["id"]).to eq(item.id)
  end
end
