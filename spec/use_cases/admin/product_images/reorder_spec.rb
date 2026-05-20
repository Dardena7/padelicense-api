require "rails_helper"

RSpec.describe Admin::ProductImages::Reorder do
  let(:product) { create(:product, category: create(:category)) }
  let!(:image_a) { create(:product_image, product:, position: 0) }
  let!(:image_b) { create(:product_image, product:, position: 1) }
  let!(:image_c) { create(:product_image, product:, position: 2) }

  it "reorders images by the given IDs" do
    result = described_class.run(
      product:,
      image_ids: [ image_c.id, image_a.id, image_b.id ]
    )

    expect(result.map(&:id)).to eq([ image_c.id, image_a.id, image_b.id ])
    expect(image_c.reload.position).to eq(0)
    expect(image_a.reload.position).to eq(1)
    expect(image_b.reload.position).to eq(2)
  end
end
