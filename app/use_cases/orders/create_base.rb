module Orders
  module CreateBase
    private

    def validate_cart!
      raise ActiveRecord::RecordNotFound, "Cart is empty" if @cart.items.empty?
    end

    def build_line_items(order)
      @cart.items.includes(product_variant: :product).each do |item|
        variant = item.product_variant
        order.line_items.build(
          product_variant: variant,
          product_name: variant.product.name,
          variant_name: variant.name,
          unit_price_cents: variant.effective_price,
          quantity: item.quantity
        )
      end
    end

    def calculate_total
      @cart.items.includes(product_variant: :product).sum do |item|
        item.product_variant.effective_price * item.quantity
      end
    end

    def address_snapshot(address)
      {
        line1: address.line1,
        line2: address.try(:line2),
        city: address.city,
        postal_code: address.postal_code,
        country_iso: address.country_iso
      }.compact
    end

    def create_payment_intent(order)
      Stripe::PaymentIntent.create(
        amount: order.total_cents,
        currency: "eur",
        metadata: {
          order_uuid: order.uuid,
          order_number: order.number
        }
      )
    end

    def finalize_order(order)
      order.save!

      payment_intent = create_payment_intent(order)
      order.update!(stripe_payment_intent_id: payment_intent.id)

      @cart.items.destroy_all

      { order:, client_secret: payment_intent.client_secret }
    end
  end
end
