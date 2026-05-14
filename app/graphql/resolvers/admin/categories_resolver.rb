module Resolvers
  module Admin
    class CategoriesResolver < Resolvers::BaseResolver
      type [ Types::CategoryType ], null: false
      description "List all categories with translations (admin only)"

      def authorized?
        policy = AdminPolicy.new(context[:current_user], nil)
        raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

        true
      end

      def resolve
        ::Category.where(parent_id: nil).order(:position).includes(:subcategories)
      end
    end
  end
end
