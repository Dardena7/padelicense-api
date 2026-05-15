module Admin
  module ProductVariants
    class Create < BaseUseCase
      def initialize(product:, name:, sku:, stock_quantity: 0, price_cents: nil)
        @product = product
        @name = name
        @sku = sku
        @stock_quantity = stock_quantity
        @price_cents = price_cents
      end

      private

      def call
        @product.variants.create!(
          name: @name,
          sku: @sku,
          stock_quantity: @stock_quantity,
          price_cents: @price_cents
        )
      end
    end
  end
end
