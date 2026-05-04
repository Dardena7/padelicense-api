class Order < ApplicationRecord
  PENDING = "pending".freeze
  PAID = "paid".freeze
  SHIPPED = "shipped".freeze
  DELIVERED = "delivered".freeze
  CANCELLED = "cancelled".freeze
  STATUSES = [ PENDING, PAID, SHIPPED, DELIVERED, CANCELLED ].freeze

  belongs_to :user
  has_many :line_items, dependent: :destroy

  enum :status, STATUSES.index_by(&:itself)

  validates :number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :total_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :shipping_address_snapshot, presence: true

  before_validation :generate_number, on: :create

  private

  def generate_number
    self.number ||= "PAD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end
end
