module Cart
  class UpdateItem < BaseUseCase
    def initialize(user:, cart_item:, quantity:)
      @user = user
      @cart_item = cart_item
      @quantity = quantity
    end

    private

    def call
      cart = @user.cart
      raise ActiveRecord::RecordNotFound, "Cart not found" unless cart
      raise ActiveRecord::RecordNotFound, "Item not in cart" unless cart.items.include?(@cart_item)

      @cart_item.update!(quantity: @quantity)

      cart.reload
    end
  end
end
