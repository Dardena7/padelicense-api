module Admin
  module Products
    class Update < BaseUseCase
      def initialize(product:, attributes:)
        @product = product
        @attributes = attributes
      end

      private

      def call
        @product.category = @attributes[:category] if @attributes[:category]
        @product.base_price_cents = @attributes[:base_price_cents] if @attributes[:base_price_cents]
        @product.brand = @attributes[:brand] unless @attributes[:brand].nil?
        @product.status = @attributes[:status] if @attributes[:status]
        @product.featured = @attributes[:featured] unless @attributes[:featured].nil?
        apply_translations
        @product.save!
        @product
      end

      def apply_translations
        @attributes[:translations].each do |t|
          I18n.with_locale(t[:locale]) do
            @product.name = t[:name]
            @product.slug = t[:slug]
            @product.description = t[:description]
          end
        end
      end
    end
  end
end
