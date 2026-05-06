module Types
  module Product
    class VariantType < Types::BaseObject
      graphql_name "ProductVariant"
      implements Types::NodeType

      field :name, String, null: false
      field :sku, String, null: false
      field :price_cents, Integer
      field :effective_price, Integer, null: false
      field :stock_quantity, Integer, null: false
      field :product, Types::ProductType, null: false
      field :images, [ Types::Product::ImageType ], null: false
    end
  end
end
