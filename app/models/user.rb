class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :refresh_tokens, dependent: :destroy

  ROLES = [ "customer", "admin" ].freeze

  enum :role, ROLES.index_by(&:itself)

  validates :first_name, presence: true
  validates :last_name, presence: true
end
