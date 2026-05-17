module Types
  module Product
    class OrderByEnum < Types::BaseEnum
      graphql_name "ProductOrderBy"
      description "Sort order for products"

      value "NEWEST", "Most recent first", value: "newest"
      value "PRICE_ASC", "Price low to high", value: "price_asc"
      value "PRICE_DESC", "Price high to low", value: "price_desc"
      value "NAME_ASC", "Name A to Z", value: "name_asc"
    end
  end
end
