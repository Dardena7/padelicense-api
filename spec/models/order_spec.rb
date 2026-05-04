require "rails_helper"

RSpec.describe Order do
  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:total_cents) }
    it { is_expected.to validate_numericality_of(:total_cents).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:shipping_address_snapshot) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(pending: "pending", paid: "paid", shipped: "shipped", delivered: "delivered", cancelled: "cancelled").backed_by_column_of_type(:string) }
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
