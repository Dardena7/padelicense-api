module Mutations
  module Admin
    module ProductVariants
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateVariant"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :attributes, Types::Product::VariantAttributesInput, required: true

        field :variant, Types::Product::VariantType, null: false

        def authorized?(product:, attributes:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, attributes:)
          variant = ::Admin::ProductVariants::Create.run(product:, attributes: attributes.to_h)
          { variant: }
        end
      end
    end
  end
end
