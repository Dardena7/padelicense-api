require "rails_helper"
require "ostruct"

RSpec.describe Orders::CreateGuest do
  let(:cart) { create(:cart, :guest) }
  let(:guest_email) { "guest@example.com" }
  let(:shipping_address) do
    OpenStruct.new(
      line1: "Rue de la Loi 1",
      line2: "Apt 3",
      city: "Bruxelles",
      postal_code: "1000",
      country_iso: "BE"
    )
  end
  let(:payment_intent) do
    double("Stripe::PaymentIntent", id: "pi_test_guest_123", client_secret: "pi_test_guest_123_secret")
  end

  before do
    allow(Stripe::PaymentIntent).to receive(:create).and_return(payment_intent)
  end

  context "with a valid cart" do
    let(:variant) { create(:product_variant, price_cents: 3000, stock_quantity: 10) }

    before do
      create(:cart_item, cart:, product_variant: variant, quantity: 2)
    end

    it "creates an order without a user" do
      result = described_class.run(cart:, guest_email:, shipping_address:)

      order = result[:order]
      expect(order).to be_persisted
      expect(order.user).to be_nil
      expect(order.guest_email).to eq("guest@example.com")
    end

    it "creates an order with correct attributes" do
      result = described_class.run(cart:, guest_email:, shipping_address:)

      order = result[:order]
      expect(order.status).to eq("pending")
      expect(order.total_cents).to eq(6000)
      expect(order.number).to start_with("PAD-")
    end

    it "snapshots the shipping address" do
      result = described_class.run(cart:, guest_email:, shipping_address:)

      snapshot = result[:order].shipping_address_snapshot
      expect(snapshot["line1"]).to eq("Rue de la Loi 1")
      expect(snapshot["line2"]).to eq("Apt 3")
      expect(snapshot["city"]).to eq("Bruxelles")
      expect(snapshot["postal_code"]).to eq("1000")
      expect(snapshot["country_iso"]).to eq("BE")
    end

    it "creates line items with snapshotted data" do
      result = described_class.run(cart:, guest_email:, shipping_address:)

      line_item = result[:order].line_items.first
      expect(line_item.product_name).to eq(variant.product.name)
      expect(line_item.variant_name).to eq(variant.name)
      expect(line_item.unit_price_cents).to eq(3000)
      expect(line_item.quantity).to eq(2)
    end

    it "creates a Stripe PaymentIntent" do
      described_class.run(cart:, guest_email:, shipping_address:)

      expect(Stripe::PaymentIntent).to have_received(:create).with(
        hash_including(amount: 6000, currency: "eur")
      )
    end

    it "returns the client secret" do
      result = described_class.run(cart:, guest_email:, shipping_address:)

      expect(result[:client_secret]).to eq("pi_test_guest_123_secret")
    end

    it "empties the cart after order creation" do
      described_class.run(cart:, guest_email:, shipping_address:)

      expect(cart.items.reload.count).to eq(0)
    end
  end

  context "with an empty cart" do
    it "raises an error" do
      expect {
        described_class.run(cart:, guest_email:, shipping_address:)
      }.to raise_error(ActiveRecord::RecordNotFound, "Cart is empty")
    end
  end
end
