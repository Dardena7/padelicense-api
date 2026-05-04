module Types
  module Cart
    class ItemInput < Types::BaseInputObject
      graphql_name "CartItemInput"

      argument :product_variant_id, ID, required: true, loads: Types::Product::VariantType
      argument :quantity, Integer, required: true
    end
  end
end
