FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer { nil }
    merchant { nil }
  end
end
