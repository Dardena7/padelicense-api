require "rails_helper"

RSpec.describe CartItem do
  describe "validations" do
    subject { create(:cart_item) }

    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
    it { is_expected.to validate_uniqueness_of(:product_variant_id).scoped_to(:cart_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product_variant) }
  end
end
