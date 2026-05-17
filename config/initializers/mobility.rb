Mobility.configure do
  plugins do
    backend :table
    active_record
    reader
    writer
    backend_reader
    query
    cache
    presence
    # [LOCALE] Update fallbacks and locale_accessors when adding a new locale
    fallbacks({ fr: :en, nl: :en })
    locale_accessors [ :en, :fr, :nl ]
  end
end
