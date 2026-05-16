module Admin
  module Categories
    class Create < BaseUseCase
      def initialize(translations:, parent: nil, position: nil)
        @translations = translations
        @parent = parent
        @position = position
      end

      private

      MAX_DEPTH = 3

      class TooDeep < StandardError; end

      def call
        raise TooDeep, "Maximum category depth is #{MAX_DEPTH}" if depth_of(@parent) >= MAX_DEPTH

        category = ::Category.new(parent: @parent, position: @position || next_position)
        apply_translations(category)
        category.save!
        category
      end

      def next_position
        ::Category.where(parent_id: @parent&.id).maximum(:position).to_i + 1
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
