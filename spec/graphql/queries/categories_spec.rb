require "rails_helper"

RSpec.describe "categories query" do
  let(:query) do
    <<~GQL
      query {
        categories {
          name
          slug
          subcategories {
            name
            slug
          }
        }
      }
    GQL
  end

  it "returns root categories with subcategories" do
    rackets = create(:category, name: "Rackets", slug: "rackets")
    create(:category, name: "Control", slug: "control", parent: rackets)
    create(:category, name: "Power", slug: "power", parent: rackets)
    create(:category, name: "Balls", slug: "balls")

    result = AppSchema.execute(query)
    categories = result.dig("data", "categories")

    expect(categories.length).to eq(2)

    rackets_data = categories.find { |c| c["slug"] == "rackets" }
    expect(rackets_data["subcategories"].length).to eq(2)
    expect(rackets_data["subcategories"].map { |s| s["name"] }).to contain_exactly("Control", "Power")

    balls_data = categories.find { |c| c["slug"] == "balls" }
    expect(balls_data["subcategories"]).to be_empty
  end
end
