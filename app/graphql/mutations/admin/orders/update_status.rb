module Mutations
  module Admin
    module Orders
      class UpdateStatus < Mutations::BaseMutation
        graphql_name "AdminUpdateOrderStatus"

        argument :order_id, ID, required: true, loads: Types::OrderType
        argument :status, Types::Order::StatusEnum, required: true

        field :order, Types::OrderType, null: false

        def authorized?(order:, status:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(order:, status:)
          updated_order = ::Admin::Orders::UpdateStatus.run(order:, new_status: status)
          { order: updated_order }
        rescue ::Admin::Orders::UpdateStatus::InvalidTransition => e
          raise GraphQL::ExecutionError, e.message
        end
      end
    end
  end
end
