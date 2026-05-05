module Types
  module Order
    class LineItemType < Types::BaseObject
      graphql_name "LineItem"
      implements Types::NodeType

      field :product_name, String, null: false
      field :variant_name, String, null: false
      field :unit_price_cents, Integer, null: false
      field :quantity, Integer, null: false
      field :product_variant, Types::Product::VariantType, null: false
    end
  end
end
