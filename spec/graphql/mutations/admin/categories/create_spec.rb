require "rails_helper"

RSpec.describe "adminCreateCategory mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminCreateCategoryInput!) {
        adminCreateCategory(input: $input) {
          category {
            id
            name
            translations { locale name slug }
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:translations) do
    [
      { locale: "EN", name: "Shoes", slug: "shoes" },
      { locale: "FR", name: "Chaussures", slug: "chaussures" },
      { locale: "NL", name: "Schoenen", slug: "schoenen" }
    ]
  end

  it "creates a category with translations" do
    result = AppSchema.execute(
      mutation,
      variables: { input: { translations: } },
      context: { current_user: admin }
    )

    data = result.dig("data", "adminCreateCategory", "category")
    expect(data["name"]).to eq("Shoes")
    expect(data["translations"].size).to eq(3)

    fr = data["translations"].find { |t| t["locale"] == "FR" }
    expect(fr["name"]).to eq("Chaussures")
  end

  it "creates with parent" do
    parent = create(:category)
    parent_id = AppSchema.id_from_object(parent, Types::CategoryType, {})

    result = AppSchema.execute(
      mutation,
      variables: { input: { translations:, parentId: parent_id, position: 1 } },
      context: { current_user: admin }
    )

    data = result.dig("data", "adminCreateCategory", "category")
    expect(data).to be_present

    created = Category.find_by(position: 1)
    expect(created.parent).to eq(parent)
  end
end
