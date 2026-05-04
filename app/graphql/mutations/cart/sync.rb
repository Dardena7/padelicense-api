module Mutations
  module Cart
    class Sync < Mutations::BaseMutation
      graphql_name "SyncCart"

      argument :items, [Types::Cart::ItemInput], required: true

      field :cart, Types::CartType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(items:)
        resolved_items = items.map do |item|
          {
            product_variant: item.product_variant,
            quantity: item.quantity
          }
        end

        cart = ::Carts::Sync.run(
          user: context[:current_user],
          items: resolved_items
        )

        { cart: cart }
      end
    end
  end
end
