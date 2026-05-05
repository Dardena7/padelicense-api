require "rails_helper"

RSpec.describe Carts::AddItem do
  let(:cart) { create(:cart) }
  let(:variant) { create(:product_variant) }

  it "adds an item to the cart" do
    result = described_class.run(cart: cart, product_variant: variant)

    expect(result.items.count).to eq(1)
    expect(result.items.first.product_variant).to eq(variant)
    expect(result.items.first.quantity).to eq(1)
  end

  it "increments quantity if variant already in cart" do
    described_class.run(cart: cart, product_variant: variant, quantity: 2)
    result = described_class.run(cart: cart, product_variant: variant, quantity: 3)

    expect(result.items.count).to eq(1)
    expect(result.items.first.quantity).to eq(5)
  end

  it "adds different variants as separate items" do
    other_variant = create(:product_variant)

    described_class.run(cart: cart, product_variant: variant)
    result = described_class.run(cart: cart, product_variant: other_variant)

    expect(result.items.count).to eq(2)
  end

  it "uses custom quantity" do
    result = described_class.run(cart: cart, product_variant: variant, quantity: 3)

    expect(result.items.first.quantity).to eq(3)
  end
end
