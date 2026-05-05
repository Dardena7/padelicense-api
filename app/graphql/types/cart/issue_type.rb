module Types
  module Cart
    class IssueType < Types::BaseObject
      graphql_name "CartIssue"

      field :type, Types::Cart::IssueTypeEnum, null: false
      field :cart_item_id, ID
      field :product_name, String
      field :requested, Integer
      field :available, Integer
    end
  end
end
