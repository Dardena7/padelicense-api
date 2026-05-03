Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.production?
      origins ENV.fetch("CORS_ORIGINS")
    else
      origins "http://localhost:3001", "https://studio.apollographql.com"
    end

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true,
      expose: [ "Authorization" ]
  end
end
