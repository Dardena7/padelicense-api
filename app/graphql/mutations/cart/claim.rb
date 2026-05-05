module Mutations
  module Cart
    class Claim < Mutations::BaseMutation
      graphql_name "ClaimGuestCart"

      argument :guest_uuid, String, required: true

      field :cart, Types::CartType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(guest_uuid:)
        cart = ::Carts::Claim.run(user: context[:current_user], guest_uuid:)

        { cart: cart }
      end
    end
  end
end
