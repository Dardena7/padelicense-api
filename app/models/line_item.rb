class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_variant

  validates :product_name, presence: true
  validates :variant_name, presence: true
  validates :unit_price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
