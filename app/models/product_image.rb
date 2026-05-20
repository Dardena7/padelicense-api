class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :product_variant, optional: true

  has_one_attached :file

  validates :image_url, presence: true, unless: :file_attached?
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def url
    if file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
    else
      image_url
    end
  end

  private

  def file_attached?
    file.attached?
  end
end
