module Types
  module Product
    class AttributesInput < Types::BaseInputObject
      graphql_name "ProductAttributesInput"

      argument :translations, [ Types::Product::TranslationInput ], required: true
      argument :category_id, ID, required: true
      argument :base_price_cents, Integer, required: true
      argument :brand, String, required: false
      argument :status, Types::Product::StatusEnum, required: false
      argument :featured, Boolean, required: false
    end
  end
end
