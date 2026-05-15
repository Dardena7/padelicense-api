require "rails_helper"

RSpec.describe Admin::Categories::Delete do
  it "deletes a category without products" do
    category = create(:category)

    result = described_class.run(category:)

    expect(result).to eq(category)
    expect(Category.exists?(category.id)).to be false
  end

  it "raises error when category has products" do
    category = create(:category)
    create(:product, category:, status: "active")

    expect {
      described_class.run(category:)
    }.to raise_error(described_class::HasProducts, /1 products/)
  end

  it "raises error even when products are archived" do
    category = create(:category)
    create(:product, category:, status: "archived")

    expect {
      described_class.run(category:)
    }.to raise_error(described_class::HasProducts)
  end
end
