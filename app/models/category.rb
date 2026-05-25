class Category < ApplicationRecord
  extend Mobility

  translates :name
  translates :slug
  translates :description

  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_many :products, dependent: :restrict_with_error

  MAX_DEPTH = 3

  validates :name, presence: true
  validates :slug, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  def self_and_descendant_ids
    ids = [id]
    subcategories.each { |child| ids.concat(child.self_and_descendant_ids) }
    ids
  end

  def depth
    d = 0
    current = self
    while current.parent
      d += 1
      current = current.parent
    end
    d
  end
end
