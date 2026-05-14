require "rails_helper"

RSpec.describe "adminCategories query" do
  let(:query) do
    <<~GQL
      query {
        adminCategories {
          id
          name
          position
          productsCount
          translations {
            locale
            name
            slug
            description
          }
          subcategories {
            id
            name
            productsCount
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }

  context "as an admin" do
    it "returns root categories with translations" do
      category = create(:category, position: 0)
      I18n.with_locale(:en) { category.update!(name: "Rackets", slug: "rackets") }
      I18n.with_locale(:fr) { category.update!(name: "Raquettes", slug: "raquettes") }

      result = AppSchema.execute(query, context: { current_user: admin })
      cats = result.dig("data", "adminCategories")

      expect(cats.size).to eq(1)
      expect(cats.first["name"]).to eq("Rackets")
      expect(cats.first["translations"].size).to eq(3)

      fr = cats.first["translations"].find { |t| t["locale"] == "FR" }
      expect(fr["name"]).to eq("Raquettes")
    end

    it "includes subcategories" do
      parent = create(:category)
      create(:category, parent:)

      result = AppSchema.execute(query, context: { current_user: admin })
      cats = result.dig("data", "adminCategories")

      expect(cats.size).to eq(1)
      expect(cats.first["subcategories"].size).to eq(1)
    end

    it "returns products count" do
      category = create(:category)
      create(:product, category:, status: "active")
      create(:product, category:, status: "draft")

      result = AppSchema.execute(query, context: { current_user: admin })
      cat = result.dig("data", "adminCategories").first

      expect(cat["productsCount"]).to eq(1)
    end
  end

  context "as a customer" do
    it "returns an error" do
      result = AppSchema.execute(query, context: { current_user: customer })

      expect(result["errors"].first["message"]).to eq("Not authorized")
    end
  end
end
