require "rails_helper"

RSpec.describe "adminDeleteProduct mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminDeleteProductInput!) {
        adminDeleteProduct(input: $input) {
          deletedId
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }

  it "deletes a product" do
    product = create(:product, category: create(:category))
    product_id = AppSchema.id_from_object(product, Types::ProductType, {})

    result = AppSchema.execute(
      mutation,
      variables: { input: { productId: product_id } },
      context: { current_user: admin }
    )

    expect(result.dig("data", "adminDeleteProduct", "deletedId")).to be_present
    expect(Product.exists?(product.id)).to be false
  end
end
