module Mutations
  module Admin
    module ProductVariants
      class Update < Mutations::BaseMutation
        graphql_name "AdminUpdateVariant"

        argument :variant_id, ID, required: true, loads: Types::Product::VariantType
        argument :name, String, required: false
        argument :sku, String, required: false
        argument :stock_quantity, Integer, required: false
        argument :price_cents, Integer, required: false

        field :variant, Types::Product::VariantType, null: false

        def authorized?(variant:, **_args)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(variant:, name: nil, sku: nil, stock_quantity: nil, price_cents: nil)
          updated = ::Admin::ProductVariants::Update.run(
            variant:, name:, sku:, stock_quantity:, price_cents:
          )
          { variant: updated }
        end
      end
    end
  end
end
