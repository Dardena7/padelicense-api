module Mutations
  module Users
    class UpdateProfile < Mutations::BaseMutation
      graphql_name "UpdateProfile"

      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :email, String, required: false
      argument :phone, String, required: false

      field :user, Types::UserType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(**attributes)
        user = context[:current_user]
        user.update!(attributes.compact)

        { user: }
      end
    end
  end
end
