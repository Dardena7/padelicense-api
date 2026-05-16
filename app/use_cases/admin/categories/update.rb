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

      MAX_DEPTH = 3

      def call
        if @parent
          raise Create::TooDeep, "Maximum category depth is #{MAX_DEPTH}" if depth_of(@parent) >= MAX_DEPTH
        end

        @category.parent = @parent
        @category.position = @position
        apply_translations
        @category.save!
        @category
      end

      def depth_of(category)
        return 0 unless category

        depth = 1
        current = category
        while current.parent
          depth += 1
          current = current.parent
        end
        depth
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
