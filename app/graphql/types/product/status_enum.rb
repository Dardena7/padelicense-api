module Types
  module Product
    class StatusEnum < Types::BaseEnum
      graphql_name "ProductStatus"
      description "Status of a product"

      value "DRAFT", "Product is not visible to customers", value: ::Product::DRAFT
      value "ACTIVE", "Product is visible and available", value: ::Product::ACTIVE
      value "ARCHIVED", "Product is no longer available", value: ::Product::ARCHIVED
    end
  end
end
