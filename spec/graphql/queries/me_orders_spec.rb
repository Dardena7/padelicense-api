require "rails_helper"

RSpec.describe "me query — orders" do
  let(:query) do
    <<~GQL
      query {
        me {
          orders {
            number
            status
            totalCents
            lineItems {
              productName
              variantName
              unitPriceCents
              quantity
            }
          }
        }
      }
    GQL
  end

  it "returns the user's orders with line items" do
    user = create(:user)
    order = create(:order, :paid, user:, total_cents: 5000)
    create(:line_item, order:, product_name: "Pro Racket", variant_name: "Blue", unit_price_cents: 2500, quantity: 2)

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "me", "orders")

    expect(data.length).to eq(1)
    expect(data.first["number"]).to eq(order.number)
    expect(data.first["status"]).to eq("PAID")
    expect(data.first["totalCents"]).to eq(5000)
    expect(data.first["lineItems"].first["productName"]).to eq("Pro Racket")
  end

  it "returns empty array when user has no orders" do
    user = create(:user)

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "me", "orders")

    expect(data).to eq([])
  end
end
