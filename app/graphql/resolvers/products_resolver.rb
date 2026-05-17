module Resolvers
  class ProductsResolver < Resolvers::BaseResolver
    type Types::ProductType.connection_type, null: false
    description "List products with optional filters"

    argument :category_slug, String, required: false
    argument :featured, Boolean, required: false
    argument :status, Types::Product::StatusEnum, required: false
    argument :search, String, required: false
    argument :order_by, Types::Product::OrderByEnum, required: false
    argument :min_price, Integer, required: false
    argument :max_price, Integer, required: false

    def resolve(category_slug: nil, featured: nil, status: nil, search: nil, order_by: nil, min_price: nil, max_price: nil)
      scope = ProductPolicy::Scope.new(context[:current_user], Product).resolve

      Products::Search.run(scope:, category_slug:, featured:, status:, search:, order_by:, min_price:, max_price:)
    end
  end
end
