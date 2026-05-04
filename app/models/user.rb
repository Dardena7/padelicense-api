class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :refresh_tokens, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error
  has_one :cart, dependent: :destroy

  CUSTOMER = "customer".freeze
  ADMIN = "admin".freeze
  ROLES = [ CUSTOMER, ADMIN ].freeze

  enum :role, ROLES.index_by(&:itself)

  validates :first_name, presence: true
  validates :last_name, presence: true
end
