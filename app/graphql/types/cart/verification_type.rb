module Types
  module Cart
    class VerificationType < Types::BaseObject
      graphql_name "CartVerification"

      field :valid, Boolean, null: false
      field :issues, [ Types::Cart::IssueType ], null: false
    end
  end
end
