module Resolvers
  module Admin
    class DashboardResolver < Resolvers::BaseResolver
    type Types::Admin::DashboardType, null: false
    description "Dashboard stats for admin users"

    def authorized?
      policy = AdminPolicy.new(context[:current_user], nil)
      raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

      true
    end

    def resolve
      ::Admin::Dashboard::Stats.run
    end
    end
  end
end
