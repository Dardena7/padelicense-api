require "rails_helper"

RSpec.describe Carts::Claim do
  let(:user) { create(:user) }
  let(:variant1) { create(:product_variant) }
  let(:variant2) { create(:product_variant) }

  context "when guest cart exists and user has no cart" do
    it "assigns the guest cart to the user" do
      guest_cart = create(:cart, :guest)
      create(:cart_item, cart: guest_cart, product_variant: variant1, quantity: 2)
      guest_uuid = guest_cart.guest_uuid

      result = described_class.run(user: user, guest_uuid: guest_uuid)

      expect(result.user).to eq(user)
      expect(result.guest_uuid).to be_nil
      expect(result.items.count).to eq(1)
      expect(result.items.first.quantity).to eq(2)
    end
  end

  context "when guest cart exists and user already has a cart" do
    it "merges items and destroys the guest cart" do
      user_cart = create(:cart, user: user)
      create(:cart_item, cart: user_cart, product_variant: variant1, quantity: 1)

      guest_cart = create(:cart, :guest)
      create(:cart_item, cart: guest_cart, product_variant: variant1, quantity: 3)
      create(:cart_item, cart: guest_cart, product_variant: variant2, quantity: 2)
      guest_uuid = guest_cart.guest_uuid

      result = described_class.run(user: user, guest_uuid: guest_uuid)

      expect(result).to eq(user_cart)
      expect(result.items.count).to eq(2)
      expect(result.items.find_by(product_variant: variant1).quantity).to eq(3)
      expect(result.items.find_by(product_variant: variant2).quantity).to eq(2)
      expect(Cart.find_by(id: guest_cart.id)).to be_nil
    end
  end

  context "when guest cart does not exist" do
    it "returns the user's existing cart" do
      user_cart = create(:cart, user: user)

      result = described_class.run(user: user, guest_uuid: "nonexistent-uuid")

      expect(result).to eq(user_cart)
    end

    it "creates a new cart for the user if none exists" do
      result = described_class.run(user: user, guest_uuid: "nonexistent-uuid")

      expect(result.user).to eq(user)
      expect(result.items.count).to eq(0)
    end
  end

  context "when guest cart is empty" do
    it "assigns it to the user without issues" do
      guest_cart = create(:cart, :guest)
      guest_uuid = guest_cart.guest_uuid

      result = described_class.run(user: user, guest_uuid: guest_uuid)

      expect(result.user).to eq(user)
      expect(result.items.count).to eq(0)
    end
  end
end
