module Types
  module Product
    class TranslationInput < Types::BaseInputObject
      graphql_name "ProductTranslationInput"

      argument :locale, Types::SupportedLocaleEnum, required: true
      argument :name, String, required: true
      argument :slug, String, required: true
      argument :description, String, required: false
    end
  end
end
