FactoryBot.define do
  factory :product_variant do
    product
    name { Faker::Commerce.material }
    sku { Faker::Alphanumeric.unique.alphanumeric(number: 10).upcase }
    price_cents { nil }
    stock_quantity { Faker::Number.between(from: 0, to: 100) }

    trait :with_custom_price do
      price_cents { Faker::Number.between(from: 1000, to: 50000) }
    end

    trait :out_of_stock do
      stock_quantity { 0 }
    end
  end
end
