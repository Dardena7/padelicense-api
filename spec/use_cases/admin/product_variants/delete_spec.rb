require "rails_helper"

RSpec.describe Admin::ProductVariants::Delete do
  it "deletes a variant" do
    variant = create(:product_variant)

    described_class.run(variant:)

    expect(ProductVariant.exists?(variant.id)).to be false
  end
end
