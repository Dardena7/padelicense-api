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
    field :alternate_slugs, [ Types::LocalizedValueType ], null: false

    def alternate_slugs
      I18n.available_locales.filter_map do |locale|
        slug = object.slug_backend.read(locale)
        { locale: locale.to_s, value: slug } if slug.present?
      end
    end
  end
end
