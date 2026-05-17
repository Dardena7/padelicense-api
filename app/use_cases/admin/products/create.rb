module Admin
  module Products
    class Create < BaseUseCase
      def initialize(attributes:)
        @attributes = attributes
      end

      private

      def call
        product = ::Product.new(
          category: @attributes[:category],
          base_price_cents: @attributes[:base_price_cents],
          brand: @attributes[:brand],
          status: @attributes[:status] || ::Product::DRAFT,
          featured: @attributes[:featured] || false
        )
        apply_translations(product)
        product.save!
        create_default_variant(product)
        product
      end

      def create_default_variant(product)
        slug = @attributes[:translations].first&.dig(:slug) || product.id.to_s
        product.variants.create!(
          name: "Default",
          sku: "#{slug}-default",
          stock_quantity: 0
        )
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
