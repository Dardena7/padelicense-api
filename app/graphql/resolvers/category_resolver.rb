module Resolvers
  class CategoryResolver < Resolvers::BaseResolver
    type Types::CategoryType, null: true
    description "Find a category by slug"

    argument :slug, String, required: true

    def resolve(slug:)
      Category.i18n.find_by(slug:)
    end
  end
end
