module Mutations
  module Admin
    module ProductVariants
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateVariant"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :name, String, required: true
        argument :sku, String, required: true
        argument :stock_quantity, Integer, required: false
        argument :price_cents, Integer, required: false

        field :variant, Types::Product::VariantType, null: false

        def authorized?(product:, name:, sku:, **_args)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, name:, sku:, stock_quantity: 0, price_cents: nil)
          variant = ::Admin::ProductVariants::Create.run(
            product:, name:, sku:, stock_quantity:, price_cents:
          )
          { variant: }
        end
      end
    end
  end
end
