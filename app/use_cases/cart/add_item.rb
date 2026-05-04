module Cart
  class AddItem < BaseUseCase
    def initialize(user:, product_variant:, quantity: 1)
      @user = user
      @product_variant = product_variant
      @quantity = quantity
    end

    private

    def call
      cart = @user.cart || @user.create_cart!
      item = cart.items.find_by(product_variant: @product_variant)

      if item
        item.update!(quantity: item.quantity + @quantity)
      else
        cart.items.create!(product_variant: @product_variant, quantity: @quantity)
      end

      cart.reload
    end
  end
end
