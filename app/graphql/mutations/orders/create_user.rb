module Mutations
  module Orders
    class CreateUser < Mutations::BaseMutation
      graphql_name "CreateUserOrder"

      argument :address_id, ID, required: true, loads: Types::AddressType

      field :order, Types::OrderType, null: false
      field :client_secret, String, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(address:)
        user = context[:current_user]
        cart = user.cart

        result = ::Orders::CreateUser.run(user:, cart:, shipping_address: address)

        { order: result[:order], client_secret: result[:client_secret] }
      end
    end
  end
end
