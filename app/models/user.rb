class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :refresh_tokens, dependent: :destroy

  enum :role, { customer: 0, admin: 1 }

  validates :first_name, presence: true
  validates :last_name, presence: true
end
