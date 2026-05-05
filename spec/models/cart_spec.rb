require "rails_helper"

RSpec.describe Cart do
  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:items).class_name("CartItem").dependent(:destroy) }
  end

  describe "validations" do
    it "is valid with a user" do
      cart = create(:cart)
      expect(cart).to be_valid
    end

    it "is valid as guest (auto-generates guest_uuid)" do
      cart = create(:cart, :guest)
      expect(cart).to be_valid
      expect(cart.guest_uuid).to be_present
    end
  end

  describe "#guest?" do
    it "returns true for guest cart" do
      cart = create(:cart, :guest)
      expect(cart).to be_guest
    end

    it "returns false for user cart" do
      cart = create(:cart)
      expect(cart).not_to be_guest
    end
  end
end
