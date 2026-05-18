module Products
  class Search < BaseUseCase
    NEWEST = "newest".freeze
    PRICE_ASC = "price_asc".freeze
    PRICE_DESC = "price_desc".freeze
    NAME_ASC = "name_asc".freeze

    def initialize(scope:, filters: {})
      @scope = scope
      @filters = filters
    end

    private

    def call
      products = @scope.includes(:category, :variants, :images)
      products = products.by_category(@filters[:category_slug]) if @filters[:category_slug]
      products = products.featured if @filters[:featured]
      products = products.by_status(@filters[:status]) if @filters[:status]
      products = products.search_by_name(@filters[:search]) if @filters[:search].present?
      products = products.min_price(@filters[:min_price]) if @filters[:min_price]
      products = products.max_price(@filters[:max_price]) if @filters[:max_price]
      apply_order(products)
    end

    def apply_order(products)
      case @filters[:order_by]
      when PRICE_ASC
        products.order(base_price_cents: :asc)
      when PRICE_DESC
        products.order(base_price_cents: :desc)
      when NAME_ASC
        products.i18n.order(:name)
      else
        products.order(created_at: :desc)
      end
    end
  end
end
