class Product < ApplicationRecord
  extend Mobility

  DRAFT = "draft".freeze
  ACTIVE = "active".freeze
  ARCHIVED = "archived".freeze
  STATUSES = [ DRAFT, ACTIVE, ARCHIVED ].freeze

  translates :name
  translates :slug
  translates :description

  belongs_to :category
  has_many :images, class_name: "ProductImage", dependent: :destroy
  has_many :variants, class_name: "ProductVariant", dependent: :destroy

  enum :status, STATUSES.index_by(&:itself)

  validates :name, presence: true
  validates :slug, presence: true
  validates :base_price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  scope :by_category, ->(slug) {
    category = Category.i18n.find_by(slug:)
    category ? where(category_id: category.self_and_descendant_ids) : none
  }
  scope :featured, -> { where(featured: true) }
  scope :by_status, ->(status) { where(status:) }
  scope :search_by_name, ->(term) {
    sanitized = term.gsub(/[%_\\]/) { |c| "\\#{c}" }
    where("id IN (SELECT product_id FROM product_translations WHERE name ILIKE ?)", "%#{sanitized}%")
  }
  scope :min_price, ->(cents) { where("base_price_cents >= ?", cents) }
  scope :max_price, ->(cents) { where("base_price_cents <= ?", cents) }
end
