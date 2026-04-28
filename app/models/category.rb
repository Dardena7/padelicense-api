class Category < ApplicationRecord
  extend Mobility

  translates :name
  translates :slug
  translates :description

  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true
  validates :slug, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
