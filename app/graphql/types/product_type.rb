module Types
  class ProductType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = ProductPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :name, String, null: false
    field :slug, String, null: false
    field :description, String
    field :brand, String
    field :base_price_cents, Integer, null: false
    field :status, Types::Product::StatusEnum, null: false
    field :featured, Boolean, null: false
    field :category, Types::CategoryType, null: false
    field :variants, [ Types::Product::VariantType ], null: false
    field :images, [ Types::Product::ImageType ], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :alternate_slugs, [ Types::LocalizedValueType ], null: false

    def alternate_slugs
      I18n.available_locales.filter_map do |locale|
        slug = object.slug_backend.read(locale)
        { locale: locale.to_s, value: slug } if slug.present?
      end
    end
  end
end
