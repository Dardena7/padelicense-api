module Resolvers
  class CategoriesResolver < Resolvers::BaseResolver
    type [ Types::CategoryType ], null: false
    description "List root categories (without parent)"

    def resolve
      policy_scope(Category).where(parent_id: nil).order(:position)
    end

    private

    def policy_scope(scope)
      CategoryPolicy::Scope.new(context[:current_user], scope).resolve
    end
  end
end
