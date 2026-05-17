module Admin
  module Categories
    class Create < BaseUseCase
      def initialize(translations:, parent: nil, position: nil)
        @translations = translations
        @parent = parent
        @position = position
      end

      private

      class TooDeep < StandardError; end

      def call
        if @parent && @parent.depth >= ::Category::MAX_DEPTH - 1
          raise TooDeep, "Maximum category depth is #{::Category::MAX_DEPTH}"
        end

        category = ::Category.new(parent: @parent, position: @position || next_position)
        apply_translations(category)
        category.save!
        category
      end

      def next_position
        ::Category.where(parent_id: @parent&.id).maximum(:position).to_i + 1
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
