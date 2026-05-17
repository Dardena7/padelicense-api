module Admin
  module Products
    class Delete < BaseUseCase
      def initialize(product:)
        @product = product
      end

      private

      def call
        @product.destroy!
        @product
      end
    end
  end
end
