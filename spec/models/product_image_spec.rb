require "rails_helper"

RSpec.describe ProductImage do
  describe "validations" do
    it { is_expected.to validate_presence_of(:image_url) }
    it { is_expected.to validate_numericality_of(:position).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:product_variant).optional }
  end

  describe "variant nullification" do
    it "keeps the image when variant is destroyed" do
      image = create(:product_image, :for_variant)
      variant = image.product_variant

      variant.destroy

      image.reload
      expect(image).to be_persisted
      expect(image.product_variant_id).to be_nil
    end
  end
end
