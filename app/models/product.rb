class Product < ApplicationRecord
  DRAFT = "draft".freeze
  ACTIVE = "active".freeze
  ARCHIVED = "archived".freeze
  STATUSES = [ DRAFT, ACTIVE, ARCHIVED ].freeze

  belongs_to :category
  has_many :variants, class_name: "ProductVariant", dependent: :destroy
  has_many :images, class_name: "ProductImage", dependent: :destroy

  enum :status, STATUSES.index_by(&:itself)

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :base_price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true
end
