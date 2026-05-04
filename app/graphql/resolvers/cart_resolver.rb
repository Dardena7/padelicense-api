module Resolvers
  class CartResolver < Resolvers::BaseResolver
    type Types::CartType, null: true
    description "Returns the current user's cart"

    def resolve
      return nil unless context[:current_user]

      context[:current_user].cart || context[:current_user].create_cart!
    end
  end
end
