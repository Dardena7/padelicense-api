module Resolvers
  class MeResolver < Resolvers::BaseResolver
    type Types::UserType, null: true
    description "Returns the currently authenticated user"

    def resolve
      context[:current_user]
    end
  end
end
