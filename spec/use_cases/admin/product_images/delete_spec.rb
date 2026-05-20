require "rails_helper"

RSpec.describe Admin::ProductImages::Delete do
  it "deletes an image" do
    image = create(:product_image)

    described_class.run(image:)

    expect(ProductImage.exists?(image.id)).to be false
  end
end
