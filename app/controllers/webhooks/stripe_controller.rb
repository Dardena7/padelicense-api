module Webhooks
  class StripeController < ActionController::API
    def create
      event = verify_signature!
      return unless event

      case event.type
      when "payment_intent.succeeded"
        handle_payment_intent_succeeded(event)
      end

      head :ok
    end

    private

    def verify_signature!
      payload = request.body.read
      sig_header = request.headers["Stripe-Signature"]

      Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error("Stripe webhook signature verification failed: #{e.message}")
      head :bad_request
      nil
    end

    def webhook_secret
      ENV.fetch("STRIPE_WEBHOOK_SECRET")
    end

    def handle_payment_intent_succeeded(event)
      payment_intent = event.data.object
      order_uuid = payment_intent.metadata.order_uuid

      order = Order.find_by(uuid: order_uuid)
      return unless order
      return unless order.pending?

      order.paid!
    end
  end
end
