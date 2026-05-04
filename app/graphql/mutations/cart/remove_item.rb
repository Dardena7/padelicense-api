module Mutations
  module Cart
    class RemoveItem < Mutations::BaseMutation
      graphql_name "RemoveItemFromCart"

      argument :cart_item_id, ID, required: true, loads: Types::Cart::ItemType

      field :cart, Types::CartType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(cart_item:)
        cart = ::Cart::RemoveItem.run(
          user: context[:current_user],
          cart_item: cart_item
        )

        { cart: cart }
      end
    end
  end
end
