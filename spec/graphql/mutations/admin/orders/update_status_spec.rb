require "rails_helper"

RSpec.describe "adminUpdateOrderStatus mutation" do
  let(:mutation) do
    <<~GQL
      mutation($input: AdminUpdateOrderStatusInput!) {
        adminUpdateOrderStatus(input: $input) {
          order {
            id
            status
          }
        }
      }
    GQL
  end

  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }

  context "as an admin" do
    it "transitions an order status" do
      order = create(:order, :paid)
      order_id = AppSchema.id_from_object(order, Types::OrderType, {})

      result = AppSchema.execute(
        mutation,
        variables: { input: { orderId: order_id, status: "SHIPPED" } },
        context: { current_user: admin }
      )

      data = result.dig("data", "adminUpdateOrderStatus", "order")
      expect(data["status"]).to eq("SHIPPED")
      expect(order.reload.status).to eq("shipped")
    end

    it "returns error for invalid transition" do
      order = create(:order)
      order_id = AppSchema.id_from_object(order, Types::OrderType, {})

      result = AppSchema.execute(
        mutation,
        variables: { input: { orderId: order_id, status: "SHIPPED" } },
        context: { current_user: admin }
      )

      expect(result["errors"].first["message"]).to include("Cannot transition")
    end
  end

  context "as a customer" do
    it "does not update the order" do
      order = create(:order, :paid, user: customer)
      order_id = AppSchema.id_from_object(order, Types::OrderType, {})

      result = AppSchema.execute(
        mutation,
        variables: { input: { orderId: order_id, status: "SHIPPED" } },
        context: { current_user: customer }
      )

      expect(result["errors"]).to be_present
      expect(order.reload.status).to eq("paid")
    end
  end
end
