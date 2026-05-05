module Carts
  class Claim < BaseUseCase
    def initialize(user:, guest_uuid:)
      @user = user
      @guest_uuid = guest_uuid
    end

    private

    def call
      guest_cart = Cart.find_by(guest_uuid: @guest_uuid)
      return @user.cart || @user.create_cart! unless guest_cart

      user_cart = @user.cart

      if user_cart.nil?
        guest_cart.update!(user: @user, guest_uuid: nil)
        return guest_cart
      end

      merge_items(guest_cart:, user_cart:)
      guest_cart.destroy!

      user_cart.reload
    end

    def merge_items(guest_cart:, user_cart:)
      guest_cart.items.each do |guest_item|
        existing = user_cart.items.find_by(product_variant: guest_item.product_variant)

        if existing
          existing.update!(quantity: [ existing.quantity, guest_item.quantity ].max)
        else
          user_cart.items.create!(
            product_variant: guest_item.product_variant,
            quantity: guest_item.quantity
          )
        end
      end
    end
  end
end
