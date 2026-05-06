module Types
  class UserType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = UserPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :public_id, String, null: false
    field :email, String, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :phone, String
    field :role, Types::User::RoleEnum, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :addresses, [ Types::AddressType ], null: false
    field :orders, [ Types::OrderType ], null: false
  end
end
