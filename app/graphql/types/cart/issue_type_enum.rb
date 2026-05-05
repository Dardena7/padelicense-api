module Types
  module Cart
    class IssueTypeEnum < Types::BaseEnum
      graphql_name "CartIssueType"
      description "Type of issue found during cart verification"

      value "EMPTY_CART", "Cart has no items", value: Carts::Verify::EMPTY_CART
      value "PRODUCT_UNAVAILABLE", "Product is no longer active", value: Carts::Verify::PRODUCT_UNAVAILABLE
      value "INSUFFICIENT_STOCK", "Requested quantity exceeds available stock", value: Carts::Verify::INSUFFICIENT_STOCK
    end
  end
end
