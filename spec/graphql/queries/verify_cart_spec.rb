require "rails_helper"

RSpec.describe "verifyCart query" do
  let(:query) do
    <<~GQL
      query VerifyCart($guestUuid: String) {
        verifyCart(guestUuid: $guestUuid) {
          valid
          issues {
            type
            cartItemId
            productName
            requested
            available
          }
        }
      }
    GQL
  end

  context "when cart is valid" do
    it "returns valid with no issues" do
      user = create(:user)
      cart = create(:cart, user:)
      variant = create(:product_variant, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 2)

      result = AppSchema.execute(query, context: { current_user: user })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be true
      expect(data["issues"]).to be_empty
    end
  end

  context "when a product is archived" do
    it "returns product_unavailable issue" do
      user = create(:user)
      cart = create(:cart, user:)
      product = create(:product, :archived, name: "Old Racket")
      variant = create(:product_variant, product:, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = AppSchema.execute(query, context: { current_user: user })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be false
      expect(data["issues"].first["type"]).to eq("PRODUCT_UNAVAILABLE")
      expect(data["issues"].first["productName"]).to eq("Old Racket")
    end
  end

  context "when stock is insufficient" do
    it "returns insufficient_stock issue" do
      user = create(:user)
      cart = create(:cart, user:)
      variant = create(:product_variant, stock_quantity: 2)
      create(:cart_item, cart:, product_variant: variant, quantity: 5)

      result = AppSchema.execute(query, context: { current_user: user })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be false
      expect(data["issues"].first["type"]).to eq("INSUFFICIENT_STOCK")
      expect(data["issues"].first["requested"]).to eq(5)
      expect(data["issues"].first["available"]).to eq(2)
    end
  end

  context "when cart is empty" do
    it "returns empty_cart issue for user with empty cart" do
      user = create(:user)
      create(:cart, user:)

      result = AppSchema.execute(query, context: { current_user: user })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be false
      expect(data["issues"].first["type"]).to eq("EMPTY_CART")
    end
  end

  context "when no cart exists" do
    it "returns empty_cart issue for user without cart" do
      user = create(:user)

      result = AppSchema.execute(query, context: { current_user: user })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be false
      expect(data["issues"].first["type"]).to eq("EMPTY_CART")
    end

    it "returns empty_cart issue for unknown guest uuid" do
      result = AppSchema.execute(query, variables: { guestUuid: "nonexistent" })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be false
      expect(data["issues"].first["type"]).to eq("EMPTY_CART")
    end
  end

  context "with a guest cart" do
    it "verifies the guest cart by uuid" do
      cart = create(:cart, :guest)
      variant = create(:product_variant, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = AppSchema.execute(query, variables: { guestUuid: cart.guest_uuid })
      data = result.dig("data", "verifyCart")

      expect(data["valid"]).to be true
      expect(data["issues"]).to be_empty
    end
  end
end
