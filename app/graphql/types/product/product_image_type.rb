module Types
  class ProductImageType < Types::BaseObject
    implements Types::NodeType
    field :image_url, String, null: false
    field :position, Integer, null: false
    field :alt_text, String
  end
end
