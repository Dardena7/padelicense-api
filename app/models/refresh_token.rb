class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :token, uniqueness: true

  before_validation :set_token, on: :create
  before_validation :set_expires_at, on: :create

  def expired?
    expires_at < Time.current
  end

  private

  def set_token
    self.token ||= SecureRandom.hex(32)
  end

  def set_expires_at
    self.expires_at ||= 30.days.from_now
  end
end
