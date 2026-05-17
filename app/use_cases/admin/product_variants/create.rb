module Admin
  module ProductVariants
    class Create < BaseUseCase
      def initialize(product:, attributes:)
        @product = product
        @attributes = attributes
      end

      private

      def call
        @product.variants.create!(
          name: @attributes[:name],
          sku: @attributes[:sku],
          stock_quantity: @attributes[:stock_quantity] || 0,
          price_cents: @attributes[:price_cents]
        )
      end
    end
  end
end
