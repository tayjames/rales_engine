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

  it "can find an item by an attribute" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get "/api/v1/items/find?name=#{item.name}"

    found_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(item.name).to eq(found_item["data"]["attributes"]["name"])
    expect(item.id).to eq(found_item["data"]["attributes"]["id"])
    expect(item.description).to eq(found_item["data"]["attributes"]["description"])
    expect(item.unit_price).to eq(found_item["data"]["attributes"]["unit_price"])
    # expect(item.created_at).to eq(found_item["data"]["attributes"]["created_at"])
    # expect(item.updated_at).to eq(found_item["data"]["attributes"]["updated_at"])
  end

  it "can find all items that match for the given querey" do
    merchant = create(:merchant)
    item_1 = create(:item, name: "Item", merchant: merchant, created_at: "2019-08-13T00:00:00.000Z")
    item_2 = create(:item, name: "Item", merchant: merchant, updated_at: "2019-08-13T00:00:00.000Z")
    item_3 = create(:item, name: "Third Item", merchant: merchant)

    get "/api/v1/items/find_all?name=Item"

    items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(items["data"].count).to eq(2)

    get "/api/v1/items/find_all?created_at=2019-08-13T00:00:00.000Z"

    created_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(created_items["data"].count).to eq(1)

    get "/api/v1/items/find_all?updated_at=2019-08-13T00:00:00.000Z"

    updated_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(updated_items["data"].count).to eq(1)
  end

  it "can return a random item" do
    merchant = create(:merchant)
    create_list(:item, 10, merchant: merchant)

    get "/api/v1/items/random"
    expect(response).to be_successful
    random_item_1 = JSON.parse(response.body)

    get "/api/v1/items/random"
    expect(response).to be_successful
    random_item_2 = JSON.parse(response.body)

    expect(random_item_1["data"]["id"]).to_not eq(random_item_2)
  end
end
