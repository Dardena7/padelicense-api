module Types
  module Product
    class SearchInput < Types::BaseInputObject
      graphql_name "ProductSearchInput"

      argument :category_slug, String, required: false
      argument :featured, Boolean, required: false
      argument :search, String, required: false
      argument :order_by, Types::Product::OrderByEnum, required: false
      argument :min_price, Integer, required: false
      argument :max_price, Integer, required: false
      argument :status, Types::Product::StatusEnum, required: false
    end
  end
end
