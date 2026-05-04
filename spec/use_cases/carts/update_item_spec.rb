require "rails_helper"

RSpec.describe Carts::UpdateItem do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let(:item) { create(:cart_item, cart: cart, quantity: 2) }

  it "updates the item quantity" do
    result = described_class.run(user: user, cart_item: item, quantity: 5)

    expect(result.items.first.quantity).to eq(5)
  end

  it "raises if the item is not in the user's cart" do
    other_user = create(:user)
    other_cart = create(:cart, user: other_user)
    other_item = create(:cart_item, cart: other_cart)

    expect {
      described_class.run(user: user, cart_item: other_item, quantity: 1)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "raises if the user has no cart" do
    user_without_cart = create(:user)
    expect {
      described_class.run(user: user_without_cart, cart_item: item, quantity: 1)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
