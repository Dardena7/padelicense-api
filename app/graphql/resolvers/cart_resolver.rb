module Resolvers
  class CartResolver < Resolvers::BaseResolver
    type Types::CartType, null: true
    description "Returns the current user's or guest's cart"

    argument :guest_uuid, String, required: false

    def resolve(guest_uuid: nil)
      user = context[:current_user]

      return user.cart if user
      return ::Cart.find_by(guest_uuid: guest_uuid) if guest_uuid.present?

      nil
    end
  end
end
