require "rails_helper"

RSpec.describe Admin::ProductVariants::Create do
  let(:product) { create(:product, category: create(:category)) }

  it "creates a variant" do
    variant = described_class.run(product:, name: "Large", sku: "TEST-L", stock_quantity: 10)

    expect(variant).to be_persisted
    expect(variant.name).to eq("Large")
    expect(variant.sku).to eq("TEST-L")
    expect(variant.stock_quantity).to eq(10)
    expect(variant.product).to eq(product)
  end

  it "creates with custom price" do
    variant = described_class.run(product:, name: "Premium", sku: "TEST-P", price_cents: 35000)

    expect(variant.price_cents).to eq(35000)
  end
end
