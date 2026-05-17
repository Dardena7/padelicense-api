module Admin
  module Products
    class Create < BaseUseCase
      def initialize(category:, attributes:)
        @category = category
        @attributes = attributes
      end

      private

      def call
        product = ::Product.new(
          category: @category,
          base_price_cents: @attributes[:base_price_cents],
          brand: @attributes[:brand],
          status: @attributes[:status] || ::Product::DRAFT,
          featured: @attributes[:featured] || false
        )
        apply_translations(product)
        product.save!
        product
      end

      def apply_translations(product)
        @attributes[:translations].each do |t|
          I18n.with_locale(t[:locale]) do
            product.name = t[:name]
            product.slug = t[:slug]
            product.description = t[:description]
          end
        end
      end
    end
  end
end
