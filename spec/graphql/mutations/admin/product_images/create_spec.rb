require "rails_helper"

RSpec.describe "adminCreateProductImage mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminCreateProductImageInput!) {
        adminCreateProductImage(input: $input) {
          image {
            id
            imageUrl
            position
            altText
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:product) { create(:product, category: create(:category)) }

  it "creates an image from a signed blob ID" do
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("fake image"),
      filename: "photo.jpg",
      content_type: "image/jpeg"
    )
    product_id = AppSchema.id_from_object(product, Types::ProductType, {})

    result = AppSchema.execute(
      mutation,
      variables: {
        input: {
          productId: product_id,
          blobSignedId: blob.signed_id,
          altText: "A nice racket"
        }
      },
      context: { current_user: admin }
    )

    data = result.dig("data", "adminCreateProductImage", "image")
    expect(data["imageUrl"]).to be_present
    expect(data["altText"]).to eq("A nice racket")
    expect(data["position"]).to eq(0)
  end

  context "as a customer" do
    it "returns an error" do
      customer = create(:user)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new("fake"),
        filename: "photo.jpg",
        content_type: "image/jpeg"
      )
      product_id = AppSchema.id_from_object(product, Types::ProductType, {})

      result = AppSchema.execute(
        mutation,
        variables: {
          input: { productId: product_id, blobSignedId: blob.signed_id }
        },
        context: { current_user: customer }
      )

      expect(result["errors"].first["message"]).to eq("Not authorized")
    end
  end
end
