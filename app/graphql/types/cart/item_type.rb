module Types
  module Cart
    class ItemType < Types::BaseObject
      graphql_name "CartItem"

      field :id, ID, null: false
      field :quantity, Integer, null: false
      field :product_variant, Types::Product::VariantType, null: false
    end
  end
end
