FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    sequence(:slug) { |n| "#{Faker::Internet.slug}-#{n}" }
    description { Faker::Lorem.paragraph }
    category
    brand { Faker::Company.name }
    base_price_cents { Faker::Number.between(from: 1000, to: 50000) }
    status { "active" }
    featured { false }

    trait :draft do
      status { "draft" }
    end

    trait :archived do
      status { "archived" }
    end

    trait :featured do
      featured { true }
    end
  end
end
