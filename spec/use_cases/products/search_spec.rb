require "rails_helper"

RSpec.describe Products::Search do
  let(:category) { create(:category, slug: "rackets") }
  let(:other_category) { create(:category, slug: "balls") }

  let!(:active) { create(:product, name: "Alpha Racket", slug: "active-one", category: category, status: "active", base_price_cents: 20000) }
  let!(:featured) { create(:product, slug: "featured-one", category: category, status: "active", featured: true, base_price_cents: 30000) }
  let!(:draft) { create(:product, slug: "draft-one", category: category, status: "draft", base_price_cents: 10000) }
  let!(:other) { create(:product, slug: "ball-one", category: other_category, status: "active", base_price_cents: 5000) }

  it "returns all products from the given scope" do
    result = described_class.run(scope: Product.all)
    expect(result).to include(active, featured, draft, other)
  end

  it "filters by category slug" do
    result = described_class.run(scope: Product.all, filters: { category_slug: "rackets" })
    expect(result).to include(active, featured, draft)
    expect(result).not_to include(other)
  end

  it "filters by featured" do
    result = described_class.run(scope: Product.all, filters: { featured: true })
    expect(result).to eq([ featured ])
  end

  it "filters by status" do
    result = described_class.run(scope: Product.all, filters: { status: "draft" })
    expect(result).to eq([ draft ])
  end

  it "combines filters" do
    result = described_class.run(scope: Product.all, filters: { category_slug: "rackets", featured: true })
    expect(result).to eq([ featured ])
  end

  it "respects the scope (e.g. policy-filtered)" do
    active_scope = Product.where(status: "active")
    result = described_class.run(scope: active_scope, filters: { category_slug: "rackets" })
    expect(result).to include(active, featured)
    expect(result).not_to include(draft)
  end

  describe "search" do
    it "searches by product name" do
      result = described_class.run(scope: Product.all, filters: { search: "Alpha Racket" })
      expect(result).to include(active)
      expect(result).not_to include(other)
    end

    it "searches case-insensitively" do
      result = described_class.run(scope: Product.all, filters: { search: "alpha racket" })
      expect(result).to include(active)
    end

    it "searches with partial match" do
      result = described_class.run(scope: Product.all, filters: { search: "Alpha" })
      expect(result).to include(active)
    end

    it "returns empty for non-matching search" do
      result = described_class.run(scope: Product.all, filters: { search: "nonexistentproductxyz" })
      expect(result).to be_empty
    end
  end

  describe "ordering" do
    it "orders by newest first by default" do
      result = described_class.run(scope: Product.all)
      expect(result.first).to eq(other)
    end

    it "orders by price ascending" do
      result = described_class.run(scope: Product.all, filters: { order_by: "price_asc" })
      expect(result.map(&:base_price_cents)).to eq([ 5000, 10000, 20000, 30000 ])
    end

    it "orders by price descending" do
      result = described_class.run(scope: Product.all, filters: { order_by: "price_desc" })
      expect(result.map(&:base_price_cents)).to eq([ 30000, 20000, 10000, 5000 ])
    end
  end

  describe "price range" do
    it "filters by min price" do
      result = described_class.run(scope: Product.all, filters: { min_price: 15000 })
      expect(result).to include(active, featured)
      expect(result).not_to include(draft, other)
    end

    it "filters by max price" do
      result = described_class.run(scope: Product.all, filters: { max_price: 15000 })
      expect(result).to include(draft, other)
      expect(result).not_to include(active, featured)
    end

    it "filters by price range" do
      result = described_class.run(scope: Product.all, filters: { min_price: 10000, max_price: 20000 })
      expect(result).to include(active, draft)
      expect(result).not_to include(other, featured)
    end
  end
end
