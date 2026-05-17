module Types
  module Product
    class VariantAttributesInput < Types::BaseInputObject
      graphql_name "VariantAttributesInput"

      argument :name, String, required: true
      argument :sku, String, required: true
      argument :stock_quantity, Integer, required: false
      argument :price_cents, Integer, required: false
    end
  end
end
