module Carts
  class RemoveItem < BaseUseCase
    def initialize(cart:, cart_item:)
      @cart = cart
      @cart_item = cart_item
    end

    private

    def call
      raise ActiveRecord::RecordNotFound, "Item not in cart" unless @cart.items.include?(@cart_item)

      @cart_item.destroy!

      @cart.reload
    end
  end
end
