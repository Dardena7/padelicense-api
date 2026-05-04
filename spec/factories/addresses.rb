FactoryBot.define do
  factory :address do
    user
    label { "Home" }
    line1 { Faker::Address.street_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.zip_code }
    country_iso { "BE" }
  end
end
