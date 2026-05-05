module Orders
  class CreateUser < BaseUseCase
    include Orders::CreateBase

    def initialize(user:, cart:, shipping_address:)
      @user = user
      @cart = cart
      @shipping_address = shipping_address
    end

    private

    def call
      validate_cart!

      order = @user.orders.build(
        status: Order::PENDING,
        total_cents: calculate_total,
        shipping_address_snapshot: address_snapshot(@shipping_address)
      )
      build_line_items(order)

      finalize_order(order)
    end
  end
end
