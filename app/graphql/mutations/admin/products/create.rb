module Mutations
  module Admin
    module Products
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateProduct"

        argument :translations, [ Types::Product::TranslationInput ], required: true
        argument :category_id, ID, required: true, loads: Types::CategoryType
        argument :base_price_cents, Integer, required: true
        argument :brand, String, required: false
        argument :status, Types::Product::StatusEnum, required: false
        argument :featured, Boolean, required: false

        field :product, Types::ProductType, null: false

        def authorized?(category:, translations:, base_price_cents:, **_args)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(category:, translations:, base_price_cents:, brand: nil, status: nil, featured: false)
          product = ::Admin::Products::Create.run(
            translations: translations.map(&:to_h),
            category:,
            base_price_cents:,
            brand:,
            status:,
            featured:
          )
          { product: }
        end
      end
    end
  end
end
