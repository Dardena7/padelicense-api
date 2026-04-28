module Resolvers
  class ProductResolver < Resolvers::BaseResolver
    type Types::ProductType, null: true
    description "Find a product by slug"

    argument :slug, String, required: true

    def resolve(slug:)
      Product.i18n.find_by(slug: slug)
    end
  end
end
