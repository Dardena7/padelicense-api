require "rails_helper"

RSpec.describe ProductVariant do
  describe "validations" do
    subject { create(:product_variant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:sku) }
    it { is_expected.to validate_uniqueness_of(:sku) }
    it { is_expected.to validate_numericality_of(:price_cents).only_integer.is_greater_than(0).allow_nil }
    it { is_expected.to validate_numericality_of(:stock_quantity).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:images).class_name("ProductImage").dependent(:nullify) }
  end

  describe "#effective_price" do
    let(:product) { create(:product, base_price_cents: 24990) }

    it "returns the variant price when set" do
      variant = create(:product_variant, product: product, price_cents: 29990)
      expect(variant.effective_price).to eq(29990)
    end

    it "falls back to the product base price when nil" do
      variant = create(:product_variant, product: product, price_cents: nil)
      expect(variant.effective_price).to eq(24990)
    end
  end
end
