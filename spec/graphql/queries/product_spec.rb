require "rails_helper"

RSpec.describe "product query" do
  let(:query) do
    <<~GQL
      query($slug: String!) {
        product(slug: $slug) {
          name
          slug
          basePriceCents
          category {
            name
          }
          images {
            imageUrl
            position
          }
        }
      }
    GQL
  end

  it "returns a product by slug" do
    product = create(:product, name: "Speed Pro", slug: "speed-pro", status: "active")
    create(:product_image, product: product, image_url: "https://example.com/img.jpg", position: 0)

    result = AppSchema.execute(query, variables: { slug: "speed-pro" })
    data = result.dig("data", "product")

    expect(data["name"]).to eq("Speed Pro")
    expect(data["images"].length).to eq(1)
    expect(data["images"].first["imageUrl"]).to eq("https://example.com/img.jpg")
  end

  it "returns null for a non-existent slug" do
    result = AppSchema.execute(query, variables: { slug: "does-not-exist" })

    expect(result.dig("data", "product")).to be_nil
  end

  it "hides draft products from visitors" do
    create(:product, slug: "draft-one", status: "draft")

    result = AppSchema.execute(query, variables: { slug: "draft-one" })

    expect(result.dig("data", "product")).to be_nil
  end

  it "shows draft products to admins" do
    admin = create(:user, :admin)
    create(:product, name: "Draft", slug: "draft-one", status: "draft")

    result = AppSchema.execute(query, variables: { slug: "draft-one" }, context: { current_user: admin })

    expect(result.dig("data", "product", "name")).to eq("Draft")
  end
end
