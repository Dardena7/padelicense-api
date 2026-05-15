module Admin
  module ProductVariants
    class Update < BaseUseCase
      def initialize(variant:, name: nil, sku: nil, stock_quantity: nil, price_cents: nil)
        @variant = variant
        @name = name
        @sku = sku
        @stock_quantity = stock_quantity
        @price_cents = price_cents
      end

      private

      def call
        @variant.name = @name if @name
        @variant.sku = @sku if @sku
        @variant.stock_quantity = @stock_quantity if @stock_quantity
        @variant.price_cents = @price_cents
        @variant.save!
        @variant
      end
    end
  end
end
