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
    field :status, String, null: false
    field :featured, Boolean, null: false
    field :category, Types::CategoryType, null: false
    field :variants, [ Types::ProductVariantType ], null: false
    field :images, [ Types::ProductImageType ], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
