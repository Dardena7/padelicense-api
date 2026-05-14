module Admin
  module Categories
    class Create < BaseUseCase
      def initialize(translations:, parent: nil, position: nil)
        @translations = translations
        @parent = parent
        @position = position
      end

      private

      def call
        category = ::Category.new(parent: @parent, position: @position)
        apply_translations(category)
        category.save!
        category
      end

      def apply_translations(category)
        @translations.each do |t|
          I18n.with_locale(t[:locale]) do
            category.name = t[:name]
            category.slug = t[:slug]
            category.description = t[:description]
          end
        end
      end
    end
  end
end
