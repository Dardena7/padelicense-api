module Admin
  module Categories
    class Delete < BaseUseCase
      class HasProducts < StandardError; end

      def initialize(category:)
        @category = category
      end

      private

      def call
        raise HasProducts, "Cannot delete category with #{products_count} products" if products_count > 0

        @category.destroy!
        @category
      end

      def products_count
        @products_count ||= @category.products.count
      end
    end
  end
end
