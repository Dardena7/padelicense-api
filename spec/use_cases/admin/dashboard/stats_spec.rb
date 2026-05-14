require "rails_helper"

RSpec.describe Admin::Dashboard::Stats do
  let(:category) { create(:category) }

  describe "order_counts_by_status" do
    it "returns counts grouped by status" do
      create(:order, :paid)
      create(:order, :paid)
      create(:order, :shipped)
      create(:order)

      result = described_class.run
      counts = result[:order_counts_by_status]

      expect(counts["pending"]).to eq(1)
      expect(counts["paid"]).to eq(2)
      expect(counts["shipped"]).to eq(1)
    end
  end

  describe "product_counts_by_status" do
    it "returns counts grouped by status" do
      create(:product, category:)
      create(:product, category:)
      create(:product, :draft, category:)
      create(:product, :archived, category:)

      result = described_class.run
      counts = result[:product_counts_by_status]

      expect(counts["active"]).to eq(2)
      expect(counts["draft"]).to eq(1)
      expect(counts["archived"]).to eq(1)
    end
  end

  describe "revenue" do
    # Freeze to Friday so 3.days.ago is still within the same week (Monday-based)
    around { |example| travel_to(Time.zone.local(2026, 5, 15, 14, 0, 0)) { example.run } }

    it "sums total_cents of paid/shipped/delivered orders" do
      create(:order, :paid, total_cents: 10000, created_at: 1.hour.ago)
      create(:order, :shipped, total_cents: 5000, created_at: 2.hours.ago)
      create(:order, total_cents: 20000, created_at: 1.hour.ago) # pending — excluded
      create(:order, :paid, total_cents: 8000, created_at: 2.days.ago) # outside today

      result = described_class.run

      expect(result[:revenue_today_cents]).to eq(15000)
    end

    it "calculates weekly revenue" do
      create(:order, :paid, total_cents: 10000, created_at: 1.day.ago)
      create(:order, :paid, total_cents: 5000, created_at: 3.days.ago)
      create(:order, :paid, total_cents: 20000, created_at: 2.weeks.ago) # outside this week

      result = described_class.run

      expect(result[:revenue_this_week_cents]).to eq(15000)
    end

    it "calculates monthly revenue" do
      create(:order, :paid, total_cents: 10000, created_at: 1.day.ago)
      create(:order, :shipped, total_cents: 5000, created_at: 2.weeks.ago)
      create(:order, :paid, total_cents: 20000, created_at: 2.months.ago) # outside this month

      result = described_class.run

      expect(result[:revenue_this_month_cents]).to eq(15000)
    end
  end

  describe "recent_orders" do
    it "returns the 10 most recent orders" do
      12.times { |i| create(:order, created_at: i.days.ago) }

      result = described_class.run

      expect(result[:recent_orders].size).to eq(10)
      expect(result[:recent_orders].first.created_at).to be > result[:recent_orders].last.created_at
    end
  end

  describe "low_stock_variants" do
    it "returns active product variants with stock below threshold" do
      active_product = create(:product, category:)
      low = create(:product_variant, product: active_product, stock_quantity: 2)
      _ok = create(:product_variant, product: active_product, stock_quantity: 10)

      result = described_class.run

      expect(result[:low_stock_variants]).to include(low)
      expect(result[:low_stock_variants]).not_to include(_ok)
    end

    it "excludes variants from draft and archived products" do
      draft_product = create(:product, :draft, category:)
      create(:product_variant, product: draft_product, stock_quantity: 0)

      archived_product = create(:product, :archived, category:)
      create(:product_variant, product: archived_product, stock_quantity: 1)

      result = described_class.run

      expect(result[:low_stock_variants]).to be_empty
    end

    it "orders by stock quantity ascending" do
      product = create(:product, category:)
      v3 = create(:product_variant, product:, stock_quantity: 3)
      v0 = create(:product_variant, product:, stock_quantity: 0)
      v1 = create(:product_variant, product:, stock_quantity: 1)

      result = described_class.run

      expect(result[:low_stock_variants].to_a).to eq([ v0, v1, v3 ])
    end
  end
end
