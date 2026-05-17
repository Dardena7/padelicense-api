module Mutations
  module Admin
    module ProductVariants
      class Delete < Mutations::BaseMutation
        graphql_name "AdminDeleteVariant"

        argument :variant_id, ID, required: true, loads: Types::Product::VariantType

        field :deleted_id, ID, null: false

        def authorized?(variant:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(variant:)
          id = variant.id
          ::Admin::ProductVariants::Delete.run(variant:)
          { deleted_id: id }
        end
      end
    end
  end
end
