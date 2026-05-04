FactoryBot.define do
  factory :line_item do
    order
    product_variant
    product_name { Faker::Commerce.product_name }
    variant_name { Faker::Commerce.material }
    unit_price_cents { Faker::Number.between(from: 500, to: 50000) }
    quantity { Faker::Number.between(from: 1, to: 5) }
  end
end
