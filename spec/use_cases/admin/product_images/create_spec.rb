require "rails_helper"

RSpec.describe Admin::ProductImages::Create do
  let(:product) { create(:product, category: create(:category)) }

  it "creates an image with an attached file" do
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("fake image data"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    image = described_class.run(product:, blob_signed_id: blob.signed_id)

    expect(image).to be_persisted
    expect(image.file).to be_attached
    expect(image.position).to eq(0)
    expect(image.product).to eq(product)
  end

  it "sets alt text" do
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("fake image data"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    image = described_class.run(product:, blob_signed_id: blob.signed_id, alt_text: "A racket")

    expect(image.alt_text).to eq("A racket")
  end

  it "auto-increments position" do
    create(:product_image, product:, position: 0)
    create(:product_image, product:, position: 1)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("fake image data"),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )

    image = described_class.run(product:, blob_signed_id: blob.signed_id)

    expect(image.position).to eq(2)
  end
end
