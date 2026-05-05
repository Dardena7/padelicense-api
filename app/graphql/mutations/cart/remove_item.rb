module Mutations
  module Cart
    class RemoveItem < Mutations::Cart::BaseCartMutation
      graphql_name "RemoveItemFromCart"

      argument :cart_item_id, ID, required: true, loads: Types::Cart::ItemType

      field :cart, Types::CartType, null: false

      def resolve(cart_item:, guest_uuid: nil)
        cart = resolve_cart(guest_uuid:)

        result = ::Carts::RemoveItem.run(cart:, cart_item:)

        { cart: result }
      end
    end
  end
end
