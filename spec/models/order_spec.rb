require "rails_helper"

RSpec.describe Order do
  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:total_cents) }
    it { is_expected.to validate_numericality_of(:total_cents).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:shipping_address_snapshot) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(pending: "pending", paid: "paid", shipped: "shipped", delivered: "delivered", cancelled: "cancelled").backed_by_column_of_type(:string) }
  end

  describe "user or guest email" do
    it "is valid with a user and no guest email" do
      order = build(:order, user: create(:user), guest_email: nil)
      expect(order).to be_valid
    end

    it "is valid with a guest email and no user" do
      order = build(:order, user: nil, guest_email: "guest@example.com")
      expect(order).to be_valid
    end

    it "is invalid without user and without guest email" do
      order = build(:order, user: nil, guest_email: nil)
      expect(order).not_to be_valid
      expect(order.errors[:guest_email]).to be_present
    end
  end

  describe "number generation" do
    it "generates a number automatically" do
      order = create(:order)
      expect(order.number).to match(/\APAD-\d{8}-[A-F0-9]{6}\z/)
    end

    it "generates unique numbers" do
      order1 = create(:order)
      order2 = create(:order)
      expect(order1.number).not_to eq(order2.number)
    end
  end
end
