module Mutations
  module Cart
    class BaseCartMutation < Mutations::BaseMutation
      argument :guest_uuid, String, required: false

      def resolve_cart(guest_uuid: nil)
        user = context[:current_user]

        return user.cart || user.create_cart! if user
        return ::Cart.find_by!(guest_uuid: guest_uuid) if guest_uuid.present?

        ::Cart.create!
      end
    end
  end
end
