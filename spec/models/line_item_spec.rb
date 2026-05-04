require "rails_helper"

RSpec.describe LineItem do
  describe "validations" do
    it { is_expected.to validate_presence_of(:product_name) }
    it { is_expected.to validate_presence_of(:variant_name) }
    it { is_expected.to validate_presence_of(:unit_price_cents) }
    it { is_expected.to validate_numericality_of(:unit_price_cents).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product_variant) }
  end
end
