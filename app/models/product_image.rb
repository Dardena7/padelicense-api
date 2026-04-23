class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :product_variant, optional: true

  validates :image_url, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
