require "rails_helper"

RSpec.describe Carts::Sync do
  let(:user) { create(:user) }
  let(:variant1) { create(:product_variant) }
  let(:variant2) { create(:product_variant) }

  it "creates a cart and adds items" do
    cart = described_class.run(
      user: user,
      items: [
        { product_variant: variant1, quantity: 2 },
        { product_variant: variant2, quantity: 1 }
      ]
    )

    expect(cart.items.count).to eq(2)
    expect(cart.items.find_by(product_variant: variant1).quantity).to eq(2)
    expect(cart.items.find_by(product_variant: variant2).quantity).to eq(1)
  end

  it "keeps the higher quantity when item already exists" do
    cart = create(:cart, user: user)
    create(:cart_item, cart: cart, product_variant: variant1, quantity: 5)

    result = described_class.run(
      user: user,
      items: [{ product_variant: variant1, quantity: 2 }]
    )

    expect(result.items.find_by(product_variant: variant1).quantity).to eq(5)
  end

  it "updates quantity when local is higher than server" do
    cart = create(:cart, user: user)
    create(:cart_item, cart: cart, product_variant: variant1, quantity: 1)

    result = described_class.run(
      user: user,
      items: [{ product_variant: variant1, quantity: 3 }]
    )

    expect(result.items.find_by(product_variant: variant1).quantity).to eq(3)
  end

  it "preserves existing items not in sync list" do
    cart = create(:cart, user: user)
    create(:cart_item, cart: cart, product_variant: variant1, quantity: 2)

    result = described_class.run(
      user: user,
      items: [{ product_variant: variant2, quantity: 1 }]
    )

    expect(result.items.count).to eq(2)
  end
end
