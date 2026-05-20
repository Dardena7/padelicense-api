module Admin
  module ProductImages
    class Delete < BaseUseCase
      def initialize(image:)
        @image = image
      end

      private

      def call
        @image.destroy!
        @image
      end
    end
  end
end
