module Products
  class Search < BaseUseCase
    VALID_ORDER_BY = %w[newest price_asc price_desc name_asc].freeze

    def initialize(scope:, filters: {}, category_slug: nil, featured: nil)
      @scope = scope
      @category_slug = category_slug
      @featured = featured
      @status = filters[:status]
      @search = filters[:search]
      @order_by = filters[:order_by]
      @min_price = filters[:min_price]
      @max_price = filters[:max_price]
    end

    private

    def call
      products = @scope.includes(:category, :variants, :images)
      products = filter_by_category(products)
      products = filter_by_featured(products)
      products = filter_by_status(products)
      products = filter_by_search(products)
      products = filter_by_price(products)
      apply_order(products)
    end

    def filter_by_category(products)
      return products unless @category_slug

      products.where(category: Category.i18n.where(slug: @category_slug))
    end

    def filter_by_featured(products)
      return products unless @featured

      products.where(featured: true)
    end

    def filter_by_status(products)
      return products unless @status

      products.where(status: @status)
    end

    def filter_by_search(products)
      return products unless @search.present?

      term = "%#{sanitize_search(@search)}%"
      products.where(
        "products.id IN (SELECT product_id FROM product_translations WHERE name ILIKE ?)",
        term
      )
    end

    def filter_by_price(products)
      products = products.where("base_price_cents >= ?", @min_price) if @min_price
      products = products.where("base_price_cents <= ?", @max_price) if @max_price
      products
    end

    def apply_order(products)
      case @order_by
      when "price_asc"
        products.order(base_price_cents: :asc)
      when "price_desc"
        products.order(base_price_cents: :desc)
      when "name_asc"
        products.i18n.order(:name)
      else
        products.order(created_at: :desc)
      end
    end

    def sanitize_search(term)
      term.gsub(/[%_\\]/) { |c| "\\#{c}" }
    end
  end
end
