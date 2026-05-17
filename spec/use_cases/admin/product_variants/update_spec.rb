require "rails_helper"

RSpec.describe Admin::ProductVariants::Update do
  let(:variant) { create(:product_variant) }

  it "updates variant attributes" do
    described_class.run(
      variant:,
      attributes: { name: "XL", sku: "NEW-SKU", stock_quantity: 20 }
    )

    variant.reload
    expect(variant.name).to eq("XL")
    expect(variant.sku).to eq("NEW-SKU")
    expect(variant.stock_quantity).to eq(20)
  end

  it "updates price" do
    described_class.run(variant:, attributes: { price_cents: 42000 })

    variant.reload
    expect(variant.price_cents).to eq(42000)
  end
end
