require "rails_helper"

RSpec.describe "adminDeleteCategory mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminDeleteCategoryInput!) {
        adminDeleteCategory(input: $input) {
          deletedId
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }

  it "deletes a category without products" do
    category = create(:category)
    category_id = AppSchema.id_from_object(category, Types::CategoryType, {})

    result = AppSchema.execute(
      mutation,
      variables: { input: { categoryId: category_id } },
      context: { current_user: admin }
    )

    expect(result.dig("data", "adminDeleteCategory", "deletedId")).to be_present
    expect(Category.exists?(category.id)).to be false
  end

  it "returns error when category has active products" do
    category = create(:category)
    create(:product, category:, status: "active")
    category_id = AppSchema.id_from_object(category, Types::CategoryType, {})

    result = AppSchema.execute(
      mutation,
      variables: { input: { categoryId: category_id } },
      context: { current_user: admin }
    )

    expect(result["errors"].first["message"]).to include("products")
    expect(Category.exists?(category.id)).to be true
  end
end
