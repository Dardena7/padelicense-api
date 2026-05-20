class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :product_variant, optional: true

  has_one_attached :file

  validates :image_url, presence: true, unless: :file_attached?
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def url
    if file.attached?
      host = ENV.fetch("API_HOST", "http://localhost:3000")
      "#{host}#{Rails.application.routes.url_helpers.rails_storage_proxy_path(file)}"
    else
      image_url
    end
  end

  private

  def file_attached?
    file.attached?
  end
end
