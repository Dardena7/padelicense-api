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
    fallbacks({ fr: :en, nl: :en })
    locale_accessors [ :en, :fr, :nl ]
  end
end
