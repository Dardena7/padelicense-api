module Types
  module Admin
    class LowStockVariantType < Types::BaseObject
      graphql_name "AdminLowStockVariant"

      field :id, ID, null: false
      field :name, String, null: false
      field :sku, String, null: false
      field :stock_quantity, Integer, null: false
      field :product_name, String, null: false

      def product_name
        I18n.with_locale(:en) { object.product.name }
      end
    end
  end
end
