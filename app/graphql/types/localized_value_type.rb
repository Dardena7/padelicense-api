module Types
  class LocalizedValueType < Types::BaseObject
    field :locale, Types::SupportedLocaleEnum, null: false
    field :value, String, null: false
  end
end
