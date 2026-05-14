module Types
  module Category
    class TranslationType < Types::BaseObject
      graphql_name "CategoryTranslation"

      field :locale, Types::SupportedLocaleEnum, null: false
      field :name, String, null: false
      field :slug, String, null: false
      field :description, String
    end
  end
end
