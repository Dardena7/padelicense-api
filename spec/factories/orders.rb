FactoryBot.define do
  factory :order do
    user
    total_cents { Faker::Number.between(from: 1000, to: 100000) }
    shipping_address_snapshot do
      {
        line1: Faker::Address.street_address,
        city: Faker::Address.city,
        postal_code: Faker::Address.zip_code,
        country_iso: "BE"
      }
    end

    trait :paid do
      status { "paid" }
      stripe_payment_intent_id { "pi_#{SecureRandom.hex(12)}" }
    end

    trait :shipped do
      status { "shipped" }
      stripe_payment_intent_id { "pi_#{SecureRandom.hex(12)}" }
    end
  end
end
