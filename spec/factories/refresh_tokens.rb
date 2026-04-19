FactoryBot.define do
  factory :refresh_token do
    user

    trait :expired do
      expires_at { 1.day.ago }
    end
  end
end
