require "rails_helper"

RSpec.describe Admin::Orders::UpdateStatus do
  describe "valid transitions" do
    it "transitions paid to shipped" do
      order = create(:order, :paid)

      result = described_class.run(order:, new_status: Order::SHIPPED)

      expect(result.status).to eq("shipped")
    end

    it "transitions shipped to delivered" do
      order = create(:order, :shipped)

      result = described_class.run(order:, new_status: Order::DELIVERED)

      expect(result.status).to eq("delivered")
    end

    it "transitions paid to cancelled" do
      order = create(:order, :paid)

      result = described_class.run(order:, new_status: Order::CANCELLED)

      expect(result.status).to eq("cancelled")
    end

    it "transitions shipped to cancelled" do
      order = create(:order, :shipped)

      result = described_class.run(order:, new_status: Order::CANCELLED)

      expect(result.status).to eq("cancelled")
    end

    it "transitions pending to cancelled" do
      order = create(:order)

      result = described_class.run(order:, new_status: Order::CANCELLED)

      expect(result.status).to eq("cancelled")
    end
  end

  describe "invalid transitions" do
    it "rejects pending to shipped" do
      order = create(:order)

      expect {
        described_class.run(order:, new_status: Order::SHIPPED)
      }.to raise_error(described_class::InvalidTransition, /Cannot transition from pending to shipped/)
    end

    it "rejects delivered to any status" do
      order = create(:order, :paid)
      order.update!(status: Order::DELIVERED)

      expect {
        described_class.run(order:, new_status: Order::CANCELLED)
      }.to raise_error(described_class::InvalidTransition)
    end

    it "rejects cancelled to any status" do
      order = create(:order, :paid)
      order.update!(status: Order::CANCELLED)

      expect {
        described_class.run(order:, new_status: Order::SHIPPED)
      }.to raise_error(described_class::InvalidTransition)
    end

    it "rejects paid to delivered (must go through shipped)" do
      order = create(:order, :paid)

      expect {
        described_class.run(order:, new_status: Order::DELIVERED)
      }.to raise_error(described_class::InvalidTransition)
    end
  end
end
