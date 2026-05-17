module Admin
  module ProductVariants
    class Update < BaseUseCase
      def initialize(variant:, attributes:)
        @variant = variant
        @attributes = attributes
      end

      private

      def call
        @variant.name = @attributes[:name] if @attributes[:name]
        @variant.sku = @attributes[:sku] if @attributes[:sku]
        @variant.stock_quantity = @attributes[:stock_quantity] if @attributes[:stock_quantity]
        @variant.price_cents = @attributes[:price_cents]
        @variant.save!
        @variant
      end
    end
  end
end
