module Products
  class Search < BaseUseCase
    def initialize(scope:, category_slug: nil, featured: nil, status: nil)
      @scope = scope
      @category_slug = category_slug
      @featured = featured
      @status = status
    end

    private

    def call
      products = @scope.includes(:category, :variants, :images)
      products = products.where(category: Category.i18n.where(slug: @category_slug)) if @category_slug
      products = products.where(featured: true) if @featured
      products = products.where(status: @status) if @status
      products.order(created_at: :desc)
    end
  end
end
