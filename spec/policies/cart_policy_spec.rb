require "rails_helper"

RSpec.describe CartPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "#show?" do
    it "allows user to see their own cart" do
      cart = create(:cart, user: user)
      expect(described_class.new(user, cart).show?).to be_truthy
    end

    it "denies user from seeing another user's cart" do
      cart = create(:cart, user: other_user)
      expect(described_class.new(user, cart).show?).to be_falsey
    end

    it "allows admin to see any user's cart" do
      cart = create(:cart, user: user)
      expect(described_class.new(admin, cart).show?).to be_truthy
    end

    it "allows access to guest carts" do
      cart = create(:cart, :guest)
      expect(described_class.new(nil, cart).show?).to be_truthy
    end
  end

  describe "#update?" do
    it "allows user to update their own cart" do
      cart = create(:cart, user: user)
      expect(described_class.new(user, cart).update?).to be_truthy
    end

    it "denies user from updating another user's cart" do
      cart = create(:cart, user: other_user)
      expect(described_class.new(user, cart).update?).to be_falsey
    end

    it "allows updating guest carts" do
      cart = create(:cart, :guest)
      expect(described_class.new(nil, cart).update?).to be_truthy
    end
  end
end
