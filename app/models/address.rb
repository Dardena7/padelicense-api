class Address < ApplicationRecord
  belongs_to :user

  validates :line1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country_iso, presence: true, length: { is: 2 }
end
