require "rails_helper"

RSpec.describe Carts::Verify do
  let(:cart) { create(:cart) }

  context "when all items are valid" do
    it "returns valid with no issues" do
      variant = create(:product_variant, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 2)

      result = described_class.run(cart:)

      expect(result[:valid]).to be true
      expect(result[:issues]).to be_empty
    end
  end

  context "when a product is archived" do
    it "returns a product_unavailable issue" do
      product = create(:product, :archived, name: "Old Racket")
      variant = create(:product_variant, product:, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues]).to contain_exactly(
        hash_including(type: "product_unavailable", product_name: "Old Racket")
      )
    end
  end

  context "when a product is draft" do
    it "returns a product_unavailable issue" do
      product = create(:product, :draft)
      variant = create(:product_variant, product:, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues]).to contain_exactly(
        hash_including(type: "product_unavailable")
      )
    end
  end

  context "when stock is insufficient" do
    it "returns an insufficient_stock issue" do
      variant = create(:product_variant, stock_quantity: 2)
      create(:cart_item, cart:, product_variant: variant, quantity: 5)

      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues]).to contain_exactly(
        hash_including(type: "insufficient_stock", requested: 5, available: 2)
      )
    end
  end

  context "when stock is zero" do
    it "returns an insufficient_stock issue" do
      variant = create(:product_variant, :out_of_stock)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues]).to contain_exactly(
        hash_including(type: "insufficient_stock", available: 0)
      )
    end
  end

  context "with multiple issues" do
    it "returns all issues" do
      archived_product = create(:product, :archived)
      archived_variant = create(:product_variant, product: archived_product, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: archived_variant, quantity: 1)

      low_stock_variant = create(:product_variant, stock_quantity: 1)
      create(:cart_item, cart:, product_variant: low_stock_variant, quantity: 3)

      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues].size).to eq(2)
      expect(result[:issues].map { |i| i[:type] }).to contain_exactly(
        "product_unavailable", "insufficient_stock"
      )
    end
  end

  context "with an empty cart" do
    it "returns an empty_cart issue" do
      result = described_class.run(cart:)

      expect(result[:valid]).to be false
      expect(result[:issues]).to contain_exactly(
        hash_including(type: "empty_cart")
      )
    end
  end
end
