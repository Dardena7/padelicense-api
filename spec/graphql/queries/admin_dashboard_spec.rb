require "rails_helper"

RSpec.describe "adminDashboard query" do
  let(:query) do
    <<~GQL
      query {
        adminDashboard {
          orderCountsByStatus { status count }
          productCountsByStatus { status count }
          revenueTodayCents
          revenueThisWeekCents
          revenueThisMonthCents
          recentOrders {
            id
            number
            status
            totalCents
          }
          lowStockVariants {
            id
            name
            sku
            stockQuantity
            product {
              id
              name
            }
          }
        }
      }
    GQL
  end

  let(:category) { create(:category) }
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }

  context "as an admin" do
    it "returns dashboard stats" do
      product = create(:product, category:)
      create(:product_variant, product:, stock_quantity: 2)
      create(:order, :paid, total_cents: 10000, created_at: 1.hour.ago)

      result = AppSchema.execute(query, context: { current_user: admin })
      data = result.dig("data", "adminDashboard")

      expect(data["revenueTodayCents"]).to eq(10000)
      expect(data["recentOrders"].size).to eq(1)
      expect(data["lowStockVariants"].size).to eq(1)
      expect(data["lowStockVariants"].first["stockQuantity"]).to eq(2)
      expect(data["productCountsByStatus"]).to include({ "status" => "active", "count" => 1 })
    end
  end

  context "as a customer" do
    it "returns null with an error" do
      result = AppSchema.execute(query, context: { current_user: customer })

      expect(result.dig("data", "adminDashboard")).to be_nil
      expect(result["errors"].first["message"]).to eq("Not authorized")
    end
  end

  context "as a visitor (not authenticated)" do
    it "returns null with an error" do
      result = AppSchema.execute(query, context: { current_user: nil })

      expect(result.dig("data", "adminDashboard")).to be_nil
      expect(result["errors"].first["message"]).to eq("Not authorized")
    end
  end
end
