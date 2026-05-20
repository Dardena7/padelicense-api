module Admin
  module ProductImages
    class Reorder < BaseUseCase
      def initialize(product:, image_ids:)
        @product = product
        @image_ids = image_ids
      end

      private

      def call
        @image_ids.each_with_index do |id, index|
          @product.images.find(id).update!(position: index)
        end
        @product.images.order(:position)
      end
    end
  end
end
