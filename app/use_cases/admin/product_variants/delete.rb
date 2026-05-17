module Admin
  module ProductVariants
    class Delete < BaseUseCase
      def initialize(variant:)
        @variant = variant
      end

      private

      def call
        @variant.destroy!
        @variant
      end
    end
  end
end
