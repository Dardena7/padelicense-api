module Resolvers
  module Admin
    class OrderResolver < Resolvers::BaseResolver
    type Types::OrderType, null: false
    description "Fetch a single order by ID (admin only)"

    argument :id, ID, required: true, loads: Types::OrderType

    def authorized?(order:)
      policy = AdminPolicy.new(context[:current_user], nil)
      raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

      true
    end

    def resolve(order:)
      order
    end
    end
  end
end
