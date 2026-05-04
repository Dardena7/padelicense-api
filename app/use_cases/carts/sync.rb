module Carts
  class Sync < BaseUseCase
    def initialize(user:, items:)
      @user = user
      @items = items
    end

    private

    def call
      cart = @user.cart || @user.create_cart!

      @items.each do |item_data|
        variant = item_data[:product_variant]
        quantity = item_data[:quantity]
        existing = cart.items.find_by(product_variant: variant)

        if existing
          existing.update!(quantity: [ existing.quantity, quantity ].max)
        else
          cart.items.create!(product_variant: variant, quantity: quantity)
        end
      end

      cart.reload
    end
  end
end
