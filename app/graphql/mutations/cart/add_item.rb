module Mutations
  module Cart
    class AddItem < Mutations::Cart::BaseCartMutation
      graphql_name "AddItemToCart"

      argument :product_variant_id, ID, required: true, loads: Types::Product::VariantType
      argument :quantity, Integer, required: false, default_value: 1

      field :cart, Types::CartType, null: false

      def resolve(product_variant:, quantity:, guest_uuid: nil)
        cart = resolve_cart(guest_uuid:)

        result = ::Carts::AddItem.run(cart:, product_variant:, quantity:)

        { cart: result }
      end
    end
  end
end
