module Resolvers
  module Admin
    class OrdersResolver < Resolvers::BaseResolver
    type Types::OrderType.connection_type, null: false
    description "List all orders (admin only)"

    argument :status, Types::Order::StatusEnum, required: false

    def authorized?(**_args)
      policy = AdminPolicy.new(context[:current_user], nil)
      raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

      true
    end

    def resolve(status: nil)
      scope = Order.order(created_at: :desc).includes(:line_items, :user)
      scope = scope.where(status:) if status
      scope
    end
    end
  end
end
