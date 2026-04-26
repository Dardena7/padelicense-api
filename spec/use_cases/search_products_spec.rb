require "rails_helper"

RSpec.describe SearchProducts do
  let(:category) { create(:category, slug: "rackets") }
  let(:other_category) { create(:category, slug: "balls") }

  let!(:active) { create(:product, slug: "active-one", category: category, status: "active") }
  let!(:featured) { create(:product, slug: "featured-one", category: category, status: "active", featured: true) }
  let!(:draft) { create(:product, slug: "draft-one", category: category, status: "draft") }
  let!(:other) { create(:product, slug: "ball-one", category: other_category, status: "active") }

  it "returns all products from the given scope" do
    result = described_class.run(scope: Product.all)
    expect(result).to include(active, featured, draft, other)
  end

  it "filters by category slug" do
    result = described_class.run(scope: Product.all, category_slug: "rackets")
    expect(result).to include(active, featured, draft)
    expect(result).not_to include(other)
  end

  it "filters by featured" do
    result = described_class.run(scope: Product.all, featured: true)
    expect(result).to eq([ featured ])
  end

  it "combines filters" do
    result = described_class.run(scope: Product.all, category_slug: "rackets", featured: true)
    expect(result).to eq([ featured ])
  end

  it "respects the scope (e.g. policy-filtered)" do
    active_scope = Product.where(status: "active")
    result = described_class.run(scope: active_scope, category_slug: "rackets")
    expect(result).to include(active, featured)
    expect(result).not_to include(draft)
  end

  it "orders by most recent first" do
    result = described_class.run(scope: Product.all)
    expect(result.first).to eq(other)
  end
end
