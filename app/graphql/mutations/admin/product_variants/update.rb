module Mutations
  module Admin
    module ProductVariants
      class Update < Mutations::BaseMutation
        graphql_name "AdminUpdateVariant"

        argument :variant_id, ID, required: true, loads: Types::Product::VariantType
        argument :attributes, Types::Product::VariantAttributesInput, required: true

        field :variant, Types::Product::VariantType, null: false

        def authorized?(variant:, attributes:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(variant:, attributes:)
          updated = ::Admin::ProductVariants::Update.run(variant:, attributes: attributes.to_h)
          { variant: updated }
        end
      end
    end
  end
end
