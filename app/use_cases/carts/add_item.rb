module Carts
  class AddItem < BaseUseCase
    def initialize(cart:, product_variant:, quantity: 1)
      @cart = cart
      @product_variant = product_variant
      @quantity = quantity
    end

    private

    def call
      item = @cart.items.find_by(product_variant: @product_variant)

      if item
        item.update!(quantity: item.quantity + @quantity)
      else
        @cart.items.create!(product_variant: @product_variant, quantity: @quantity)
      end

      @cart.reload
    end
  end
end
