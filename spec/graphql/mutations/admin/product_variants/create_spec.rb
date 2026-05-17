require "rails_helper"

RSpec.describe "adminCreateVariant mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminCreateVariantInput!) {
        adminCreateVariant(input: $input) {
          variant {
            id
            name
            sku
            stockQuantity
            priceCents
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }

  it "creates a variant" do
    product = create(:product, category: create(:category))
    product_id = AppSchema.id_from_object(product, Types::ProductType, {})

    result = AppSchema.execute(
      mutation,
      variables: {
        input: {
          productId: product_id,
          attributes: { name: "Large", sku: "TEST-L", stockQuantity: 10 }
        }
      },
      context: { current_user: admin }
    )

    data = result.dig("data", "adminCreateVariant", "variant")
    expect(data["name"]).to eq("Large")
    expect(data["sku"]).to eq("TEST-L")
    expect(data["stockQuantity"]).to eq(10)
  end
end
