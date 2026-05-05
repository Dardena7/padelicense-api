module Carts
  class UpdateItem < BaseUseCase
    def initialize(cart:, cart_item:, quantity:)
      @cart = cart
      @cart_item = cart_item
      @quantity = quantity
    end

    private

    def call
      raise ActiveRecord::RecordNotFound, "Item not in cart" unless @cart.items.include?(@cart_item)

      @cart_item.update!(quantity: @quantity)

      @cart.reload
    end
  end
end
