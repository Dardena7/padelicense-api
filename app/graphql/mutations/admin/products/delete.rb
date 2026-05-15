module Mutations
  module Admin
    module Products
      class Delete < Mutations::BaseMutation
        graphql_name "AdminDeleteProduct"

        argument :product_id, ID, required: true, loads: Types::ProductType

        field :deleted_id, ID, null: false

        def authorized?(product:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:)
          id = product.id
          ::Admin::Products::Delete.run(product:)
          { deleted_id: id }
        end
      end
    end
  end
end
