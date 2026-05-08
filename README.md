# Padelicense API

GraphQL API for a padel equipment e-commerce platform. Built with Rails 7.2 in API mode.

## Tech Stack

- **Framework:** Rails 7.2 (API mode), Ruby 3.3
- **Database:** PostgreSQL 16
- **Cache/Jobs:** Redis 7 + Sidekiq
- **API:** GraphQL (graphql-ruby) with Relay-style pagination and global IDs
- **Auth:** Devise + custom JWT (access token in memory, refresh token in httpOnly cookie)
- **Authorization:** Pundit policies on GraphQL types
- **i18n:** Mobility (table backend) — en, fr, nl
- **Payments:** Stripe (PaymentIntents + webhooks)
- **Tests:** RSpec, FactoryBot, Shoulda Matchers (230+ tests)

## Architecture

```
app/
  controllers/       # GraphQL endpoint, auth (REST), Stripe webhook
  graphql/
    mutations/       # Cart, Orders, Addresses, Users
    resolvers/       # Queries (products, categories, cart, verifyCart)
    types/           # GraphQL types with Pundit authorization
  models/            # 12 ActiveRecord models
  policies/          # Pundit authorization policies
  services/          # External integrations (JWT)
  use_cases/         # Business logic by domain
    addresses/       #   Create, Update, Delete
    carts/           #   AddItem, UpdateItem, RemoveItem, Claim, Verify
    orders/          #   CreateUser, CreateGuest (shared via CreateBase)
    products/        #   Search
```

**Conventions:**
- Use cases receive objects, never GraphQL IDs
- Services = external integrations, use cases = business logic
- GraphQL enums reference model constants
- Early returns over if/else

## Getting Started

### Prerequisites

- Docker & Docker Compose

### Setup

```bash
docker compose up api
# API available at http://localhost:3000
# Database created and seeded automatically
```

### Running Tests

```bash
docker compose run --rm api bundle exec rspec
```

### Linting

```bash
docker compose run --rm api bin/rubocop
docker compose run --rm api bin/brakeman --no-pager
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/graphql` | POST | GraphQL API |
| `/auth/signup` | POST | User registration |
| `/auth/login` | POST | JWT authentication |
| `/auth/refresh` | POST | Token rotation (httpOnly cookie) |
| `/auth/logout` | DELETE | Session invalidation |
| `/webhooks/stripe` | POST | Stripe payment webhooks |
| `/up` | GET | Health check |

## Environment Variables

See `.env.example` for required configuration.

| Variable | Description |
|----------|-------------|
| `STRIPE_SECRET_KEY` | Stripe test/live secret key |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signing secret |
