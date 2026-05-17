require "rails_helper"

RSpec.describe Product do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
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

  describe "scopes" do
    let(:category) { create(:category, slug: "rackets") }
    let!(:cheap) { create(:product, name: "Cheap One", category:, base_price_cents: 5000, featured: false) }
    let!(:expensive) { create(:product, name: "Expensive One", category:, base_price_cents: 30000, featured: true) }
    let!(:draft) { create(:product, :draft, name: "Draft One", category:) }
    let!(:other_cat) { create(:product, name: "Other Cat", category: create(:category, slug: "balls")) }

    describe ".by_category" do
      it "filters by category slug" do
        result = described_class.by_category("rackets")
        expect(result).to include(cheap, expensive, draft)
        expect(result).not_to include(other_cat)
      end
    end

    describe ".featured" do
      it "returns only featured products" do
        result = described_class.featured
        expect(result).to include(expensive)
        expect(result).not_to include(cheap)
      end
    end

    describe ".by_status" do
      it "filters by status" do
        result = described_class.by_status("draft")
        expect(result).to include(draft)
        expect(result).not_to include(cheap, expensive)
      end
    end

    describe ".search_by_name" do
      it "searches case-insensitively" do
        result = described_class.search_by_name("cheap")
        expect(result).to include(cheap)
        expect(result).not_to include(expensive)
      end

      it "searches with partial match" do
        result = described_class.search_by_name("Exp")
        expect(result).to include(expensive)
      end
    end

    describe ".min_price" do
      it "filters products above min price" do
        result = described_class.min_price(10000)
        expect(result).to include(expensive)
        expect(result).not_to include(cheap)
      end
    end

    describe ".max_price" do
      it "filters products below max price" do
        result = described_class.max_price(10000)
        expect(result).to include(cheap)
        expect(result).not_to include(expensive)
      end
    end
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
