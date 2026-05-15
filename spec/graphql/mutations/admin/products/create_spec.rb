require "rails_helper"

RSpec.describe "adminCreateProduct mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminCreateProductInput!) {
        adminCreateProduct(input: $input) {
          product {
            id
            name
            status
            basePriceCents
            translations { locale name slug }
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }

  it "creates a product with translations" do
    category_id = AppSchema.id_from_object(category, Types::CategoryType, {})

    result = AppSchema.execute(
      mutation,
      variables: {
        input: {
          categoryId: category_id,
          basePriceCents: 19990,
          brand: "Head",
          translations: [
            { locale: "EN", name: "Test Racket", slug: "test-racket" },
            { locale: "FR", name: "Raquette Test", slug: "raquette-test" },
            { locale: "NL", name: "Test NL", slug: "test-nl" }
          ]
        }
      },
      context: { current_user: admin }
    )

    data = result.dig("data", "adminCreateProduct", "product")
    expect(data["name"]).to eq("Test Racket")
    expect(data["status"]).to eq("DRAFT")
    expect(data["basePriceCents"]).to eq(19990)
    expect(data["translations"].size).to eq(3)
  end
end
