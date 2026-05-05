require "rails_helper"

RSpec.describe "cart query" do
  let(:query) do
    <<~GQL
      query GetCart($guestUuid: String) {
        cart(guestUuid: $guestUuid) {
          id
          guestUuid
          totalCents
          items {
            id
            quantity
            productVariant {
              name
              effectivePrice
            }
          }
        }
      }
    GQL
  end

  it "returns the user's cart when authenticated" do
    user = create(:user)
    cart = create(:cart, user:)
    variant = create(:product_variant, price_cents: 1000)
    create(:cart_item, cart:, product_variant: variant, quantity: 2)

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "cart")

    expect(data["totalCents"]).to eq(2000)
    expect(data["items"].length).to eq(1)
    expect(data["items"].first["quantity"]).to eq(2)
  end

  it "returns the guest cart by uuid" do
    cart = create(:cart, :guest)
    variant = create(:product_variant)
    create(:cart_item, cart:, product_variant: variant)

    result = AppSchema.execute(query, variables: { guestUuid: cart.guest_uuid })
    data = result.dig("data", "cart")

    expect(data["guestUuid"]).to eq(cart.guest_uuid)
    expect(data["items"].length).to eq(1)
  end

  it "returns null for unknown guest uuid" do
    result = AppSchema.execute(query, variables: { guestUuid: "nonexistent" })

    expect(result.dig("data", "cart")).to be_nil
  end

  it "returns null for unauthenticated request without guest uuid" do
    result = AppSchema.execute(query)

    expect(result.dig("data", "cart")).to be_nil
  end
end
