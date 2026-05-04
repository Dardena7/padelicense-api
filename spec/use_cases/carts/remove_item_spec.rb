require "rails_helper"

RSpec.describe Carts::RemoveItem do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:item) { create(:cart_item, cart: cart) }

  it "removes the item from the cart" do
    result = described_class.run(user: user, cart_item: item)

    expect(result.items.count).to eq(0)
  end

  it "keeps other items in the cart" do
    other_item = create(:cart_item, cart: cart)

    result = described_class.run(user: user, cart_item: item)

    expect(result.items).to contain_exactly(other_item)
  end

  it "raises if the item is not in the user's cart" do
    other_user = create(:user)
    other_cart = create(:cart, user: other_user)
    other_item = create(:cart_item, cart: other_cart)

    expect {
      described_class.run(user: user, cart_item: other_item)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
