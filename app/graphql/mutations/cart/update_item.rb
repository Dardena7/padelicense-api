module Mutations
  module Cart
    class UpdateItem < Mutations::Cart::BaseCartMutation
      graphql_name "UpdateCartItem"

      argument :cart_item_id, ID, required: true, loads: Types::Cart::ItemType
      argument :quantity, Integer, required: true

      field :cart, Types::CartType, null: false

      def resolve(cart_item:, quantity:, guest_uuid: nil)
        cart = resolve_cart(guest_uuid:)

        result = ::Carts::UpdateItem.run(cart:, cart_item:, quantity:)

        { cart: result }
      end
    end
  end
end
