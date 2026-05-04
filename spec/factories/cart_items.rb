FactoryBot.define do
  factory :cart_item do
    cart
    product_variant
    quantity { 1 }
  end
end
