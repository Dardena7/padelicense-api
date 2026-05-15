module Mutations
  module Admin
    module Categories
      class Delete < Mutations::BaseMutation
        graphql_name "AdminDeleteCategory"

        argument :category_id, ID, required: true, loads: Types::CategoryType

        field :deleted_id, ID, null: false

        def authorized?(category:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(category:)
          id = category.id
          ::Admin::Categories::Delete.run(category:)
          { deleted_id: id }
        rescue ::Admin::Categories::Delete::HasProducts => e
          raise GraphQL::ExecutionError, e.message
        end
      end
    end
  end
end
