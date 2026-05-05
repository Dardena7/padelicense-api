FactoryBot.define do
  factory :cart do
    user

    trait :guest do
      user { nil }
    end
  end
end
