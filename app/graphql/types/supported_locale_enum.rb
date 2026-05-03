module Types
  class SupportedLocaleEnum < Types::BaseEnum
    graphql_name "SupportedLocale"
    description "Supported locales"

    I18n.available_locales.each do |locale|
      value locale.to_s.upcase, value: locale.to_s
    end
  end
end
