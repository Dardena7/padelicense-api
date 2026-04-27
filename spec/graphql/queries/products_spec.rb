require "rails_helper"

RSpec.describe "products query" do
  let(:query) do
    <<~GQL
      query($first: Int) {
        products(first: $first) {
          nodes {
            name
            slug
            basePriceCents
            status
            featured
            createdAt
            category {
              name
              slug
            }
            variants {
              name
              sku
              priceCents
              effectivePrice
              stockQuantity
              images {
                imageUrl
                position
                altText
              }
            }
            images {
              imageUrl
              position
              altText
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    GQL
  end

  let(:category) { create(:category, name: "Rackets", slug: "rackets") }

  let!(:active_product) { create(:product, name: "Speed Pro", slug: "speed-pro", base_price_cents: 24990, category: category, status: "active") }
  let!(:draft_product) { create(:product, name: "Draft One", slug: "draft-one", category: category, status: "draft") }

  def extract_nodes(result)
    result.dig("data", "products", "nodes")
  end

  context "as a visitor" do
    it "returns only active products with all fields" do
      create(:product_variant, product: active_product, name: "340g", sku: "SP-340", price_cents: nil, stock_quantity: 10)
      create(:product_image, product: active_product, image_url: "https://example.com/img.jpg", position: 0, alt_text: "Front view")

      result = AppSchema.execute(query)
      nodes = extract_nodes(result)
      product = nodes.find { |p| p["slug"] == "speed-pro" }

      expect(nodes.map { |p| p["name"] }).not_to include("Draft One")

      expect(product["name"]).to eq("Speed Pro")
      expect(product["basePriceCents"]).to eq(24990)
      expect(product["status"]).to eq("ACTIVE")
      expect(product["featured"]).to be false
      expect(product["createdAt"]).to be_present
      expect(product["category"]["name"]).to eq("Rackets")
      expect(product["category"]["slug"]).to eq("rackets")

      variant = product["variants"].first
      expect(variant["name"]).to eq("340g")
      expect(variant["sku"]).to eq("SP-340")
      expect(variant["priceCents"]).to be_nil
      expect(variant["effectivePrice"]).to eq(24990)
      expect(variant["stockQuantity"]).to eq(10)

      image = product["images"].first
      expect(image["imageUrl"]).to eq("https://example.com/img.jpg")
      expect(image["position"]).to eq(0)
      expect(image["altText"]).to eq("Front view")
    end
  end

  context "as an admin" do
    let(:admin) { create(:user, :admin) }

    it "returns all products including drafts" do
      result = AppSchema.execute(query, context: { current_user: admin })
      names = extract_nodes(result).map { |p| p["name"] }

      expect(names).to include("Speed Pro", "Draft One")
    end
  end

  it "paginates results" do
    create(:product, slug: "second-active", category: category, status: "active")

    result = AppSchema.execute(query, variables: { first: 1 })
    nodes = extract_nodes(result)
    page_info = result.dig("data", "products", "pageInfo")

    expect(nodes.length).to eq(1)
    expect(page_info["hasNextPage"]).to be true
    expect(page_info["endCursor"]).to be_present
  end
end
