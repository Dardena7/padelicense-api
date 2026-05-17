module Types
  module Product
    class OrderByEnum < Types::BaseEnum
      graphql_name "ProductOrderBy"
      description "Sort order for products"

      value "NEWEST", "Most recent first", value: Products::Search::NEWEST
      value "PRICE_ASC", "Price low to high", value: Products::Search::PRICE_ASC
      value "PRICE_DESC", "Price high to low", value: Products::Search::PRICE_DESC
      value "NAME_ASC", "Name A to Z", value: Products::Search::NAME_ASC
    end
  end
end
