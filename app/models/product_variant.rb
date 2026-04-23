class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :images, class_name: "ProductImage", dependent: :nullify

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :price_cents, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def effective_price
    price_cents || product.base_price_cents
  end
end
