class Cart < ApplicationRecord
  belongs_to :user, optional: true

  has_many :items, class_name: "CartItem", dependent: :destroy

  before_validation :assign_guest_uuid, on: :create

  validate :user_or_guest_uuid_present

  def guest?
    user_id.nil?
  end

  private

  def assign_guest_uuid
    self.guest_uuid ||= SecureRandom.uuid if user_id.nil?
  end

  def user_or_guest_uuid_present
    return if user_id.present? || guest_uuid.present?

    errors.add(:base, "Cart must belong to a user or have a guest UUID")
  end
end
