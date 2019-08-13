FactoryBot.define do
  factory :merchant do
    name { "MyString" }
    association :items
    association :invoices
  end
end
