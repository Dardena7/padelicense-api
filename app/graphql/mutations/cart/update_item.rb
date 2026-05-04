module Mutations
  module Cart
    class UpdateItem < Mutations::BaseMutation
      graphql_name "UpdateCartItem"

      argument :cart_item_id, ID, required: true, loads: Types::Cart::ItemType
      argument :quantity, Integer, required: true

      field :cart, Types::CartType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(cart_item:, quantity:)
        cart = ::Carts::UpdateItem.run(
          user: context[:current_user],
          cart_item: cart_item,
          quantity: quantity
        )

        { cart: cart }
      end
    end
  end
end
