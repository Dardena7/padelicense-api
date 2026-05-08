require "rails_helper"

RSpec.describe "Webhooks::Stripe" do
  let(:webhook_secret) { "whsec_test_secret" }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("STRIPE_WEBHOOK_SECRET").and_return(webhook_secret)
  end

  def post_webhook(event_payload)
    payload = event_payload.to_json
    timestamp = Time.now
    signature = Stripe::Webhook::Signature.compute_signature(timestamp, payload, webhook_secret)
    sig_header = Stripe::Webhook::Signature.generate_header(timestamp, signature)

    post "/webhooks/stripe",
      params: payload,
      headers: {
        "Stripe-Signature" => sig_header,
        "Content-Type" => "application/json"
      }
  end

  describe "payment_intent.succeeded" do
    it "marks the order as paid" do
      order = create(:order)

      post_webhook({
        id: "evt_test_123",
        type: "payment_intent.succeeded",
        data: {
          object: {
            id: "pi_test_123",
            metadata: { order_uuid: order.uuid }
          }
        }
      })

      expect(response).to have_http_status(:ok)
      expect(order.reload.status).to eq("paid")
    end

    it "ignores already paid orders (idempotent)" do
      order = create(:order, :paid)

      post_webhook({
        id: "evt_test_456",
        type: "payment_intent.succeeded",
        data: {
          object: {
            id: "pi_test_456",
            metadata: { order_uuid: order.uuid }
          }
        }
      })

      expect(response).to have_http_status(:ok)
      expect(order.reload.status).to eq("paid")
    end

    it "ignores unknown order ids" do
      post_webhook({
        id: "evt_test_789",
        type: "payment_intent.succeeded",
        data: {
          object: {
            id: "pi_test_789",
            metadata: { order_uuid: "nonexistent-uuid" }
          }
        }
      })

      expect(response).to have_http_status(:ok)
    end
  end

  describe "unhandled event" do
    it "returns ok without processing" do
      post_webhook({
        id: "evt_test_unhandled",
        type: "customer.created",
        data: { object: { id: "cus_123" } }
      })

      expect(response).to have_http_status(:ok)
    end
  end

  describe "invalid signature" do
    it "returns bad request" do
      payload = { id: "evt_fake", type: "payment_intent.succeeded" }.to_json

      post "/webhooks/stripe",
        params: payload,
        headers: {
          "Stripe-Signature" => "t=123,v1=fake_signature",
          "Content-Type" => "application/json"
        }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
