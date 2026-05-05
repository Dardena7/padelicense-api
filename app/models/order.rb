class Order < ApplicationRecord
  PENDING = "pending".freeze
  PAID = "paid".freeze
  SHIPPED = "shipped".freeze
  DELIVERED = "delivered".freeze
  CANCELLED = "cancelled".freeze
  STATUSES = [ PENDING, PAID, SHIPPED, DELIVERED, CANCELLED ].freeze

  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  enum :status, STATUSES.index_by(&:itself)

  validates :number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :total_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :shipping_address_snapshot, presence: true
  validates :guest_email, presence: true, unless: :user_id?
  validate :user_or_guest_email_present

  before_validation :generate_number, on: :create

  private

  def generate_number
    self.number ||= "PAD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end

  def user_or_guest_email_present
    return if user_id.present? || guest_email.present?

    errors.add(:base, "Order must belong to a user or have a guest email")
  end
end
