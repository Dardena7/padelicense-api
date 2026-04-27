module Types
  class CategoryType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = CategoryPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :name, String, null: false
    field :slug, String, null: false
    field :description, String
    field :position, Integer
    field :parent, CategoryType
    field :subcategories, [ CategoryType ], null: false
  end
end
