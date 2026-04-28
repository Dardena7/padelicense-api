# Padelicense API — Rails Backend

## Conventions
- Services (`app/services/`) = external integrations (Stripe, JWT, email)
- Use cases (`app/use_cases/`) = business logic (SearchProducts, CreateOrder)
- String enums with frozen constants (`DRAFT = "draft".freeze`)
- GraphQL enums reference model constants (`value "DRAFT", "...", value: Product::DRAFT`)
- GraphQL types organized in subdirectories with Zeitwerk collapse (`types/product/`, `types/category/`)
- Pundit for authorization, policies on GraphQL types via `self.authorized?`
- Relay-style global IDs (node interface) on all GraphQL types
- Tests alongside code, not batched

## Stack
- Rails 7.2 API mode, PostgreSQL, Redis, Sidekiq
- GraphQL (graphql-ruby), Pundit
- Devise for auth, custom JWT service
- RSpec, FactoryBot, Shoulda Matchers, Faker
- Docker Compose for local dev

## Auth flow
- Access token: JWT in memory (15 min), with iss/aud claims
- Refresh token: httpOnly cookie (30 days), rotation on refresh
- Devise for password management

## Docker
- `docker compose up api` — start the server
- `docker compose run --rm api bundle exec rspec` — run tests
- `docker compose run --rm api bundle install` — install gems after Gemfile change
- No RAILS_ENV in docker-compose — Rails defaults to development, RSpec forces test
