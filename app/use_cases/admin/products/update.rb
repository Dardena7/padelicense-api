module Admin
  module Products
    class Update < BaseUseCase
      def initialize(product:, translations:, category: nil, base_price_cents: nil, brand: nil, status: nil, featured: nil)
        @product = product
        @translations = translations
        @category = category
        @base_price_cents = base_price_cents
        @brand = brand
        @status = status
        @featured = featured
      end

      private

      def call
        @product.category = @category if @category
        @product.base_price_cents = @base_price_cents if @base_price_cents
        @product.brand = @brand unless @brand.nil?
        @product.status = @status if @status
        @product.featured = @featured unless @featured.nil?
        apply_translations
        @product.save!
        @product
      end

      def apply_translations
        @translations.each do |t|
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
