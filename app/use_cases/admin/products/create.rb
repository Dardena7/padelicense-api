module Admin
  module Products
    class Create < BaseUseCase
      def initialize(translations:, category:, base_price_cents:, brand: nil, status: nil, featured: false)
        @translations = translations
        @category = category
        @base_price_cents = base_price_cents
        @brand = brand
        @status = status || ::Product::DRAFT
        @featured = featured
      end

      private

      def call
        product = ::Product.new(
          category: @category,
          base_price_cents: @base_price_cents,
          brand: @brand,
          status: @status,
          featured: @featured
        )
        apply_translations(product)
        product.save!
        product
      end

      def apply_translations(product)
        @translations.each do |t|
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
