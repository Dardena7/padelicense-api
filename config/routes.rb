Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  namespace :auth do
    post "signup", to: "registrations#create"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    post "refresh", to: "tokens#refresh"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
