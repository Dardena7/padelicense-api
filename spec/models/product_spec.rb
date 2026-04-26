require "rails_helper"

RSpec.describe Product do
  describe "validations" do
    subject { create(:product) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
    it { is_expected.to validate_presence_of(:base_price_cents) }
    it { is_expected.to validate_numericality_of(:base_price_cents).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:variants).class_name("ProductVariant").dependent(:destroy) }
    it { is_expected.to have_many(:images).class_name("ProductImage").dependent(:destroy) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(draft: "draft", active: "active", archived: "archived").backed_by_column_of_type(:string) }
  end

  describe "factory" do
    it "creates a valid product" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "creates a draft product" do
      product = build(:product, :draft)
      expect(product).to be_draft
    end

    it "creates a featured product" do
      product = build(:product, :featured)
      expect(product.featured).to be true
    end
  end
end
