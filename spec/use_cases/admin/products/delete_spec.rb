require "rails_helper"

RSpec.describe Admin::Products::Delete do
  let(:category) { create(:category) }

  it "deletes a product" do
    product = create(:product, category:)

    described_class.run(product:)

    expect(Product.exists?(product.id)).to be false
  end
end
