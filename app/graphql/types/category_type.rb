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
    field :products_count, Integer, null: false
    field :alternate_slugs, [ Types::LocalizedValueType ], null: false
    field :translations, [ Types::Category::TranslationType ], null: false

    def products_count
      object.products.active.count
    end

    def alternate_slugs
      I18n.available_locales.filter_map do |locale|
        slug = object.slug_backend.read(locale)
        { locale: locale.to_s, value: slug } if slug.present?
      end
    end

    def translations
      I18n.available_locales.map do |locale|
        {
          locale: locale.to_s,
          name: object.name_backend.read(locale) || "",
          slug: object.slug_backend.read(locale) || "",
          description: object.description_backend.read(locale)
        }
      end
    end
  end
end
