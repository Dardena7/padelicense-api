module Resolvers
  class VerifyCartResolver < Resolvers::BaseResolver
    type Types::Cart::VerificationType, null: false
    description "Verifies that all cart items are valid for checkout"

    argument :guest_uuid, String, required: false

    def resolve(guest_uuid: nil)
      cart = find_cart(guest_uuid:)

      return { valid: false, issues: [ { type: Carts::Verify::EMPTY_CART } ] } unless cart

      Carts::Verify.run(cart:)
    end

    private

    def find_cart(guest_uuid:)
      user = context[:current_user]

      return user.cart if user
      return ::Cart.find_by(guest_uuid:) if guest_uuid.present?

      nil
    end
  end
end
