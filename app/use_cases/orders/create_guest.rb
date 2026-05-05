module Orders
  class CreateGuest < BaseUseCase
    include Orders::CreateBase

    def initialize(cart:, guest_email:, shipping_address:)
      @cart = cart
      @guest_email = guest_email
      @shipping_address = shipping_address
    end

    private

    def call
      validate_cart!

      order = Order.new(
        guest_email: @guest_email,
        status: Order::PENDING,
        total_cents: calculate_total,
        shipping_address_snapshot: address_snapshot(@shipping_address)
      )
      build_line_items(order)

      finalize_order(order)
    end
  end
end
