module Admin
  module ProductImages
    class Create < BaseUseCase
      def initialize(product:, blob_signed_id:, alt_text: nil)
        @product = product
        @blob_signed_id = blob_signed_id
        @alt_text = alt_text
      end

      private

      def call
        image = @product.images.build(
          image_url: "active_storage",
          position: next_position,
          alt_text: @alt_text
        )
        image.file.attach(@blob_signed_id)
        image.save!
        image
      end

      def next_position
        max = @product.images.maximum(:position)
        max ? max + 1 : 0
      end
    end
  end
end
