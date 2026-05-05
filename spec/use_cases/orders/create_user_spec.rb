require "rails_helper"

RSpec.describe Orders::CreateUser do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:address) { create(:address, user:) }
  let(:payment_intent) do
    double("Stripe::PaymentIntent", id: "pi_test_123", client_secret: "pi_test_123_secret_456")
  end

  before do
    allow(Stripe::PaymentIntent).to receive(:create).and_return(payment_intent)
  end

  context "with a valid cart" do
    let(:variant) { create(:product_variant, price_cents: 2500, stock_quantity: 10) }

    before do
      create(:cart_item, cart:, product_variant: variant, quantity: 2)
    end

    it "creates an order with correct attributes" do
      result = described_class.run(user:, cart:, shipping_address: address)

      order = result[:order]
      expect(order).to be_persisted
      expect(order.status).to eq("pending")
      expect(order.total_cents).to eq(5000)
      expect(order.number).to start_with("PAD-")
    end

    it "snapshots the shipping address" do
      result = described_class.run(user:, cart:, shipping_address: address)

      snapshot = result[:order].shipping_address_snapshot
      expect(snapshot["line1"]).to eq(address.line1)
      expect(snapshot["city"]).to eq(address.city)
      expect(snapshot["postal_code"]).to eq(address.postal_code)
      expect(snapshot["country_iso"]).to eq(address.country_iso)
    end

    it "creates line items with snapshotted data" do
      result = described_class.run(user:, cart:, shipping_address: address)

      line_item = result[:order].line_items.first
      expect(line_item.product_name).to eq(variant.product.name)
      expect(line_item.variant_name).to eq(variant.name)
      expect(line_item.unit_price_cents).to eq(2500)
      expect(line_item.quantity).to eq(2)
      expect(line_item.product_variant).to eq(variant)
    end

    it "creates a Stripe PaymentIntent with correct amount" do
      described_class.run(user:, cart:, shipping_address: address)

      expect(Stripe::PaymentIntent).to have_received(:create).with(
        hash_including(amount: 5000, currency: "eur")
      )
    end

    it "stores the PaymentIntent ID on the order" do
      result = described_class.run(user:, cart:, shipping_address: address)

      expect(result[:order].stripe_payment_intent_id).to eq("pi_test_123")
    end

    it "returns the client secret" do
      result = described_class.run(user:, cart:, shipping_address: address)

      expect(result[:client_secret]).to eq("pi_test_123_secret_456")
    end

    it "empties the cart after order creation" do
      described_class.run(user:, cart:, shipping_address: address)

      expect(cart.items.reload.count).to eq(0)
    end
  end

  context "with multiple items" do
    it "calculates total from all items" do
      variant_a = create(:product_variant, price_cents: 1000, stock_quantity: 10)
      variant_b = create(:product_variant, price_cents: 3000, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant_a, quantity: 2)
      create(:cart_item, cart:, product_variant: variant_b, quantity: 1)

      result = described_class.run(user:, cart:, shipping_address: address)

      expect(result[:order].total_cents).to eq(5000)
      expect(result[:order].line_items.count).to eq(2)
    end
  end

  context "with a variant using product base price" do
    it "uses effective_price (falls back to base_price_cents)" do
      product = create(:product, base_price_cents: 4000)
      variant = create(:product_variant, product:, price_cents: nil, stock_quantity: 10)
      create(:cart_item, cart:, product_variant: variant, quantity: 1)

      result = described_class.run(user:, cart:, shipping_address: address)

      expect(result[:order].total_cents).to eq(4000)
      expect(result[:order].line_items.first.unit_price_cents).to eq(4000)
    end
  end

  context "with an empty cart" do
    it "raises an error" do
      expect {
        described_class.run(user:, cart:, shipping_address: address)
      }.to raise_error(ActiveRecord::RecordNotFound, "Cart is empty")
    end

    it "does not create a Stripe PaymentIntent" do
      described_class.run(user:, cart:, shipping_address: address) rescue nil

      expect(Stripe::PaymentIntent).not_to have_received(:create)
    end
  end
end
