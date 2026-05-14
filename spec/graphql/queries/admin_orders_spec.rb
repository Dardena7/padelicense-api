require "rails_helper"

RSpec.describe "adminOrders query" do
  let(:query) do
    <<~GQL
      query($status: OrderStatus) {
        adminOrders(status: $status) {
          nodes {
            id
            number
            status
            totalCents
            createdAt
            user { id email }
            guestEmail
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }

  context "as an admin" do
    it "returns all orders" do
      create(:order, :paid)
      create(:order)

      result = AppSchema.execute(query, context: { current_user: admin })
      nodes = result.dig("data", "adminOrders", "nodes")

      expect(nodes.size).to eq(2)
    end

    it "filters by status" do
      create(:order, :paid)
      create(:order)

      result = AppSchema.execute(query, variables: { status: "PAID" }, context: { current_user: admin })
      nodes = result.dig("data", "adminOrders", "nodes")

      expect(nodes.size).to eq(1)
      expect(nodes.first["status"]).to eq("PAID")
    end

    it "returns orders in reverse chronological order" do
      old = create(:order, created_at: 2.days.ago)
      recent = create(:order, created_at: 1.hour.ago)

      result = AppSchema.execute(query, context: { current_user: admin })
      nodes = result.dig("data", "adminOrders", "nodes")

      expect(nodes.first["number"]).to eq(recent.number)
      expect(nodes.last["number"]).to eq(old.number)
    end

    it "includes user info for user orders" do
      user = create(:user, email: "buyer@example.com")
      create(:order, user:)

      result = AppSchema.execute(query, context: { current_user: admin })
      node = result.dig("data", "adminOrders", "nodes").first

      expect(node["user"]["email"]).to eq("buyer@example.com")
      expect(node["guestEmail"]).to be_nil
    end

    it "includes guest email for guest orders" do
      create(:order, :guest)

      result = AppSchema.execute(query, context: { current_user: admin })
      node = result.dig("data", "adminOrders", "nodes").first

      expect(node["user"]).to be_nil
      expect(node["guestEmail"]).to be_present
    end
  end

  context "as a customer" do
    it "returns an error" do
      result = AppSchema.execute(query, context: { current_user: customer })

      expect(result["errors"].first["message"]).to eq("Not authorized")
    end
  end
end
