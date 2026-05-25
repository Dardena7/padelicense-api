require "rails_helper"

RSpec.describe "category query" do
  let(:query) do
    <<~GQL
      query($slug: String!) {
        category(slug: $slug) {
          name
          slug
          description
          productsCount
          parent {
            name
            slug
          }
          subcategories {
            name
            slug
          }
          alternateSlugs {
            locale
            value
          }
        }
      }
    GQL
  end

  it "returns a category by slug" do
    category = create(:category, name: "Rackets", slug: "rackets", description: "All rackets")

    result = AppSchema.execute(query, variables: { slug: "rackets" })
    data = result.dig("data", "category")

    expect(data["name"]).to eq("Rackets")
    expect(data["slug"]).to eq("rackets")
    expect(data["description"]).to eq("All rackets")
  end

  it "returns null for a non-existent slug" do
    result = AppSchema.execute(query, variables: { slug: "does-not-exist" })

    expect(result.dig("data", "category")).to be_nil
  end

  it "returns parent and subcategories" do
    parent = create(:category, name: "Rackets", slug: "rackets")
    child = create(:category, name: "Control", slug: "control", parent:)
    create(:category, name: "Pro", slug: "pro", parent: child)

    result = AppSchema.execute(query, variables: { slug: "control" })
    data = result.dig("data", "category")

    expect(data["parent"]["name"]).to eq("Rackets")
    expect(data["parent"]["slug"]).to eq("rackets")
    expect(data["subcategories"].first["name"]).to eq("Pro")
  end

  it "returns products count for active products only" do
    category = create(:category, name: "Rackets", slug: "rackets")
    create(:product, category:, status: "active")
    create(:product, category:, status: "active")
    create(:product, category:, status: "draft")

    result = AppSchema.execute(query, variables: { slug: "rackets" })
    data = result.dig("data", "category")

    expect(data["productsCount"]).to eq(2)
  end

  it "finds category by translated slug" do
    category = create(:category, name: "Rackets", slug: "rackets")
    Mobility.with_locale(:fr) do
      category.update!(name: "Raquettes", slug: "raquettes")
    end

    result = I18n.with_locale(:fr) do
      AppSchema.execute(query, variables: { slug: "raquettes" })
    end
    data = result.dig("data", "category")

    expect(data["name"]).to eq("Raquettes")
    expect(data["slug"]).to eq("raquettes")
  end

  it "returns alternate slugs for all locales" do
    category = create(:category, name: "Rackets", slug: "rackets")
    Mobility.with_locale(:fr) do
      category.update!(name: "Raquettes", slug: "raquettes")
    end

    result = AppSchema.execute(query, variables: { slug: "rackets" })
    slugs = result.dig("data", "category", "alternateSlugs")

    expect(slugs).to include({ "locale" => "EN", "value" => "rackets" })
    expect(slugs).to include({ "locale" => "FR", "value" => "raquettes" })
  end
end
