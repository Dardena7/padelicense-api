module Mutations
  module Orders
    class CreateGuest < Mutations::BaseMutation
      graphql_name "CreateGuestOrder"

      argument :guest_uuid, String, required: true
      argument :guest_email, String, required: true
      argument :shipping_address, Types::AddressInput, required: true

      field :order, Types::OrderType, null: false
      field :client_secret, String, null: false

      def resolve(guest_uuid:, guest_email:, shipping_address:)
        cart = ::Cart.find_by!(guest_uuid:)

        result = ::Orders::CreateGuest.run(cart:, guest_email:, shipping_address:)

        { order: result[:order], client_secret: result[:client_secret] }
      end
    end
  end
end
