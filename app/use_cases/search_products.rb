class SearchProducts < BaseUseCase
  def initialize(scope:, category_slug: nil, featured: nil)
    @scope = scope
    @category_slug = category_slug
    @featured = featured
  end

  private

  def call
    products = @scope.includes(:category, :variants, :images)
    products = products.where(category: Category.i18n.where(slug: @category_slug)) if @category_slug
    products = products.where(featured: true) if @featured
    products.order(created_at: :desc)
  end
end
