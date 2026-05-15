module Mutations
  module Admin
    module Products
      class Update < Mutations::BaseMutation
        graphql_name "AdminUpdateProduct"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :translations, [ Types::Product::TranslationInput ], required: true
        argument :category_id, ID, required: false, loads: Types::CategoryType, as: :category
        argument :base_price_cents, Integer, required: false
        argument :brand, String, required: false
        argument :status, Types::Product::StatusEnum, required: false
        argument :featured, Boolean, required: false

        field :product, Types::ProductType, null: false

        def authorized?(product:, translations:, **_args)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, translations:, category: nil, base_price_cents: nil, brand: nil, status: nil, featured: nil)
          updated = ::Admin::Products::Update.run(
            product:,
            translations: translations.map(&:to_h),
            category:,
            base_price_cents:,
            brand:,
            status:,
            featured:
          )
          { product: updated }
        end
      end
    end
  end
end
