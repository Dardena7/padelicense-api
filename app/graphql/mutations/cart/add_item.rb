module Mutations
  module Cart
    class AddItem < Mutations::BaseMutation
      graphql_name "AddItemToCart"

      argument :product_variant_id, ID, required: true, loads: Types::Product::VariantType
      argument :quantity, Integer, required: false, default_value: 1

      field :cart, Types::CartType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(product_variant:, quantity:)
        cart = ::Cart::AddItem.run(
          user: context[:current_user],
          product_variant: product_variant,
          quantity: quantity
        )

        { cart: cart }
      end
    end
  end
end
