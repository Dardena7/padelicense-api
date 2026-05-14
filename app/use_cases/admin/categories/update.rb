module Admin
  module Categories
    class Update < BaseUseCase
      def initialize(category:, translations:, parent: nil, position: nil)
        @category = category
        @translations = translations
        @parent = parent
        @position = position
      end

      private

      def call
        @category.parent = @parent
        @category.position = @position
        apply_translations
        @category.save!
        @category
      end

      def apply_translations
        @translations.each do |t|
          I18n.with_locale(t[:locale]) do
            @category.name = t[:name]
            @category.slug = t[:slug]
            @category.description = t[:description]
          end
        end
      end
    end
  end
end
