module Resolvers
  class AdminDashboardResolver < Resolvers::BaseResolver
    type Types::Admin::DashboardType, null: false
    description "Dashboard stats for admin users"

    def authorized?
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]&.admin?

      true
    end

    def resolve
      ::Admin::Dashboard::Stats.run
    end
  end
end
