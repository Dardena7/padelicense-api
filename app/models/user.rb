class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :refresh_tokens, dependent: :destroy

  CUSTOMER = "customer".freeze
  ADMIN = "admin".freeze
  ROLES = [ CUSTOMER, ADMIN ].freeze

  enum :role, ROLES.index_by(&:itself)

  validates :first_name, presence: true
  validates :last_name, presence: true
end
