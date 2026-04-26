module Types
  class ProductVariantType < Types::BaseObject
    implements Types::NodeType
    field :name, String, null: false
    field :sku, String, null: false
    field :price_cents, Integer
    field :effective_price, Integer, null: false
    field :stock_quantity, Integer, null: false
    field :images, [ Types::ProductImageType ], null: false
  end
end
