module Cart
  class RemoveItem < BaseUseCase
    def initialize(user:, cart_item:)
      @user = user
      @cart_item = cart_item
    end

    private

    def call
      cart = @user.cart
      raise ActiveRecord::RecordNotFound, "Cart not found" unless cart
      raise ActiveRecord::RecordNotFound, "Item not in cart" unless cart.items.include?(@cart_item)

      @cart_item.destroy!

      cart.reload
    end
  end
end
