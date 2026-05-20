require "rails_helper"

RSpec.describe Admin::Products::Delete do
  let(:category) { create(:category) }

  it "deletes a product" do
    product = create(:product, category:)

    described_class.run(product:)

    expect(Product.exists?(product.id)).to be false
  end

  it "deletes a product with variants and images" do
    product = create(:product, category:)
    create(:product_variant, product:)
    create(:product_image, product:)

    described_class.run(product:)

    expect(Product.exists?(product.id)).to be false
    expect(ProductVariant.where(product_id: product.id)).to be_empty
    expect(ProductImage.where(product_id: product.id)).to be_empty
  end

  it "deletes a product with images linked to variants" do
    product = create(:product, category:)
    variant = create(:product_variant, product:)
    create(:product_image, product:, product_variant: variant)

    described_class.run(product:)

    expect(Product.exists?(product.id)).to be false
    expect(ProductVariant.exists?(variant.id)).to be false
    expect(ProductImage.where(product_variant_id: variant.id)).to be_empty
  end
end
