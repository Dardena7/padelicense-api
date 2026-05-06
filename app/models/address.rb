class Address < ApplicationRecord
  belongs_to :user

  validates :line1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country_iso, presence: true, length: { is: 2 }

  before_create :set_default_if_first
  after_save :unset_other_defaults, if: :default?

  private

  def set_default_if_first
    self.default = true if user.addresses.empty?
  end

  def unset_other_defaults
    user.addresses.where.not(id:).where(default: true).update_all(default: false)
  end
end
