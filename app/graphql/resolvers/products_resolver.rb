module Resolvers
  class ProductsResolver < Resolvers::BaseResolver
    type Types::ProductType.connection_type, null: false
    description "List products with optional filters"

    argument :category_slug, String, required: false
    argument :featured, Boolean, required: false

    def resolve(category_slug: nil, featured: nil)
      scope = ProductPolicy::Scope.new(context[:current_user], Product).resolve

      Products::Search.run(scope:, category_slug:, featured:)
    end
  end
end
