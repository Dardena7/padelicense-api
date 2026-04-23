FactoryBot.define do
  factory :product_image do
    product
    image_url { Faker::Internet.url(host: "images.unsplash.com") }
    position { 0 }
    alt_text { Faker::Lorem.sentence(word_count: 3) }

    trait :for_variant do
      product_variant { association(:product_variant, product: product) }
    end
  end
end
