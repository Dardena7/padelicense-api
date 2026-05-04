require "rails_helper"

RSpec.describe Carts::AddItem do
  let(:user) { create(:user) }
  let(:variant) { create(:product_variant) }

  it "creates a cart if none exists" do
    expect { described_class.run(user: user, product_variant: variant) }
      .to change { user.reload.cart.present? }.from(false).to(true)
  end

  it "adds an item to the cart" do
    cart = described_class.run(user: user, product_variant: variant)

    expect(cart.items.count).to eq(1)
    expect(cart.items.first.product_variant).to eq(variant)
    expect(cart.items.first.quantity).to eq(1)
  end

  it "increments quantity if variant already in cart" do
    described_class.run(user: user, product_variant: variant, quantity: 2)
    cart = described_class.run(user: user, product_variant: variant, quantity: 3)

    expect(cart.items.count).to eq(1)
    expect(cart.items.first.quantity).to eq(5)
  end

  it "adds different variants as separate items" do
    other_variant = create(:product_variant)

    described_class.run(user: user, product_variant: variant)
    cart = described_class.run(user: user, product_variant: other_variant)

    expect(cart.items.count).to eq(2)
  end

  it "uses custom quantity" do
    cart = described_class.run(user: user, product_variant: variant, quantity: 3)

    expect(cart.items.first.quantity).to eq(3)
  end
end
