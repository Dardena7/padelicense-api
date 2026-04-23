FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    slug { Faker::Internet.slug }
    description { Faker::Lorem.sentence }

    trait :with_parent do
      parent { association(:category) }
    end
  end
end
