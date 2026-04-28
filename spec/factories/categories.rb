FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    sequence(:slug) { |n| "#{Faker::Internet.slug}-#{n}" }
    description { Faker::Lorem.sentence }

    trait :with_parent do
      parent { association(:category) }
    end
  end
end
