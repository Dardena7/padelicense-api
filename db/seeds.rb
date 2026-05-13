return if Rails.env.test?

def seed_category(data, parent: nil)
  en = data[:translations][:en]
  category = I18n.with_locale(:en) { Category.i18n.find_by(slug: en[:slug]) }
  category ||= Category.new

  category.parent = parent
  category.position = data[:position]

  data[:translations].each do |locale, attrs|
    I18n.with_locale(locale) do
      category.name = attrs[:name]
      category.slug = attrs[:slug]
      category.description = attrs[:description]
    end
  end

  category.save!
  category
end

def seed_product(data)
  en = data[:translations][:en]
  product = I18n.with_locale(:en) { Product.i18n.find_by(slug: en[:slug]) }
  product ||= Product.new

  product.brand = data[:brand]
  product.base_price_cents = data[:base_price_cents]
  product.category = data[:category]
  product.featured = data.fetch(:featured, false)
  product.status = data.fetch(:status, "active")

  data[:translations].each do |locale, attrs|
    I18n.with_locale(locale) do
      product.name = attrs[:name]
      product.slug = attrs[:slug]
      product.description = attrs[:description]
    end
  end

  product.save!

  variants = data.fetch(:variants, [{ name: "Default", sku: "#{en[:slug]}-default", stock_quantity: 10 }])

  variants.each do |v|
    product.variants.find_or_create_by!(sku: v[:sku]) do |pv|
      pv.name = v[:name]
      pv.stock_quantity = v[:stock_quantity]
      pv.price_cents = v[:price_cents]
    end
  end

  product
end

puts "Seeding categories..."

rackets = seed_category({
  position: 0,
  translations: {
    en: { name: "Rackets", slug: "rackets", description: "Padel rackets for all levels" },
    fr: { name: "Raquettes", slug: "raquettes", description: "Raquettes de padel pour tous les niveaux" },
    nl: { name: "Rackets", slug: "rackets", description: "Padel rackets voor alle niveaus" }
  }
})

control = seed_category(
  {
    position: 0,
    translations: {
      en: { name: "Control", slug: "control-rackets", description: "Rackets focused on precision and touch" },
      fr: { name: "Contrôle", slug: "raquettes-controle", description: "Raquettes axées sur la précision et le toucher" },
      nl: { name: "Controle", slug: "controle-rackets", description: "Rackets gericht op precisie en gevoel" }
    }
  },
  parent: rackets
)

power = seed_category(
  {
    position: 1,
    translations: {
      en: { name: "Power", slug: "power-rackets", description: "Rackets focused on power and smash" },
      fr: { name: "Puissance", slug: "raquettes-puissance", description: "Raquettes axées sur la puissance et le smash" },
      nl: { name: "Power", slug: "power-rackets", description: "Rackets gericht op kracht en smash" }
    }
  },
  parent: rackets
)

balls = seed_category({
  position: 1,
  translations: {
    en: { name: "Balls", slug: "balls", description: "Official padel balls" },
    fr: { name: "Balles", slug: "balles", description: "Balles de padel officielles" },
    nl: { name: "Ballen", slug: "ballen", description: "Officiële padel ballen" }
  }
})

shoes = seed_category({
  position: 2,
  translations: {
    en: { name: "Shoes", slug: "shoes", description: "Padel shoes for all surfaces" },
    fr: { name: "Chaussures", slug: "chaussures", description: "Chaussures de padel pour toutes les surfaces" },
    nl: { name: "Schoenen", slug: "schoenen", description: "Padel schoenen voor alle ondergronden" }
  }
})

accessories = seed_category({
  position: 3,
  translations: {
    en: { name: "Accessories", slug: "accessories", description: "Grips, bags, and more" },
    fr: { name: "Accessoires", slug: "accessoires", description: "Grips, sacs et plus encore" },
    nl: { name: "Accessoires", slug: "accessoires", description: "Grips, tassen en meer" }
  }
})

puts "Seeding products..."

[
  {
    brand: "Head", base_price_cents: 24990, category: control, featured: true,
    variants: [
      { name: "Default", sku: "head-speed-pro-default", stock_quantity: 10 }
    ],
    translations: {
      en: { name: "Head Speed Pro", slug: "head-speed-pro", description: "The Head Speed Pro offers exceptional control and a comfortable feel. Perfect for intermediate to advanced players who value precision over power." },
      fr: { name: "Head Speed Pro", slug: "head-speed-pro", description: "La Head Speed Pro offre un contrôle exceptionnel et un confort de jeu remarquable. Parfaite pour les joueurs intermédiaires à avancés qui privilégient la précision." },
      nl: { name: "Head Speed Pro", slug: "head-speed-pro", description: "De Head Speed Pro biedt uitzonderlijke controle en een comfortabel gevoel. Perfect voor gevorderde spelers die precisie verkiezen boven kracht." }
    }
  },
  {
    brand: "Bullpadel", base_price_cents: 34990, category: power, featured: true,
    variants: [
      { name: "Standard", sku: "bullpadel-vertex-04-std", stock_quantity: 3 },
      { name: "Limited Edition", sku: "bullpadel-vertex-04-ltd", stock_quantity: 0, price_cents: 39990 }
    ],
    translations: {
      en: { name: "Bullpadel Vertex 04", slug: "bullpadel-vertex-04", description: "Top-tier power racket used by professional players. Diamond shape with a high balance for maximum smash power." },
      fr: { name: "Bullpadel Vertex 04", slug: "bullpadel-vertex-04", description: "Raquette de puissance haut de gamme utilisée par les joueurs professionnels. Forme diamant avec un équilibre haut pour un smash maximum." },
      nl: { name: "Bullpadel Vertex 04", slug: "bullpadel-vertex-04", description: "Topklasse power racket gebruikt door professionele spelers. Diamantvorm met hoge balans voor maximale smash kracht." }
    }
  },
  {
    brand: "Adidas", base_price_cents: 29990, category: power, featured: false,
    translations: {
      en: { name: "Adidas Metalbone", slug: "adidas-metalbone", description: "The Metalbone combines carbon fiber construction with an aggressive diamond shape. A favorite among competitive players." },
      fr: { name: "Adidas Metalbone", slug: "adidas-metalbone", description: "La Metalbone combine une construction en fibre de carbone avec une forme diamant agressive. Un favori des joueurs compétitifs." },
      nl: { name: "Adidas Metalbone", slug: "adidas-metalbone", description: "De Metalbone combineert koolstofvezel constructie met een agressieve diamantvorm. Een favoriet onder competitieve spelers." }
    }
  },
  {
    brand: "Nox", base_price_cents: 19990, category: control, featured: false,
    translations: {
      en: { name: "Nox AT10 Genius", slug: "nox-at10-genius", description: "Agustin Tapia's signature racket. Round shape with a soft touch, ideal for players who rely on control and placement." },
      fr: { name: "Nox AT10 Genius", slug: "nox-at10-genius", description: "La raquette signature d'Agustin Tapia. Forme ronde avec un toucher doux, idéale pour les joueurs qui misent sur le contrôle et le placement." },
      nl: { name: "Nox AT10 Genius", slug: "nox-at10-genius", description: "Agustin Tapia's kenmerkende racket. Ronde vorm met een zacht gevoel, ideaal voor spelers die vertrouwen op controle en plaatsing." }
    }
  },
  {
    brand: "Wilson", base_price_cents: 27990, category: control, featured: true,
    translations: {
      en: { name: "Wilson Bela Pro v2", slug: "wilson-bela-pro-v2", description: "Fernando Belasteguin's choice. Hybrid shape offering a perfect balance between control and power." },
      fr: { name: "Wilson Bela Pro v2", slug: "wilson-bela-pro-v2", description: "Le choix de Fernando Belasteguin. Forme hybride offrant un équilibre parfait entre contrôle et puissance." },
      nl: { name: "Wilson Bela Pro v2", slug: "wilson-bela-pro-v2", description: "De keuze van Fernando Belasteguin. Hybride vorm die een perfecte balans biedt tussen controle en kracht." }
    }
  },
  {
    brand: "Head", base_price_cents: 699, category: balls, featured: false,
    variants: [
      { name: "3-pack", sku: "head-pro-s-balls-3", stock_quantity: 2 },
      { name: "12-pack", sku: "head-pro-s-balls-12", stock_quantity: 15, price_cents: 2499 }
    ],
    translations: {
      en: { name: "Head Pro S", slug: "head-pro-s-balls", description: "Official World Padel Tour ball. Pressurized for consistent bounce and durability." },
      fr: { name: "Head Pro S", slug: "head-pro-s-balles", description: "Balle officielle du World Padel Tour. Pressurisée pour un rebond constant et une bonne durabilité." },
      nl: { name: "Head Pro S", slug: "head-pro-s-ballen", description: "Officiële World Padel Tour bal. Onder druk gezet voor een consistente stuit en duurzaamheid." }
    }
  },
  {
    brand: "Asics", base_price_cents: 8990, category: shoes, featured: false,
    variants: [
      { name: "EU 41", sku: "asics-gel-padel-pro-5-41", stock_quantity: 4 },
      { name: "EU 42", sku: "asics-gel-padel-pro-5-42", stock_quantity: 1 },
      { name: "EU 43", sku: "asics-gel-padel-pro-5-43", stock_quantity: 8 },
      { name: "EU 44", sku: "asics-gel-padel-pro-5-44", stock_quantity: 0 }
    ],
    translations: {
      en: { name: "Asics Gel-Padel Pro 5", slug: "asics-gel-padel-pro-5", description: "Lightweight padel shoe with GEL cushioning. Herringbone outsole for excellent grip on all court surfaces." },
      fr: { name: "Asics Gel-Padel Pro 5", slug: "asics-gel-padel-pro-5", description: "Chaussure de padel légère avec amorti GEL. Semelle à chevrons pour une excellente adhérence sur toutes les surfaces." },
      nl: { name: "Asics Gel-Padel Pro 5", slug: "asics-gel-padel-pro-5", description: "Lichtgewicht padel schoen met GEL demping. Visgraatzool voor uitstekende grip op alle baanoppervlakken." }
    }
  },
  {
    brand: "Bullpadel", base_price_cents: 890, category: accessories, featured: false,
    translations: {
      en: { name: "Bullpadel Overgrip Pack x3", slug: "bullpadel-overgrip-pack", description: "Pack of 3 high-absorption overgrips. Provides excellent comfort and sweat management during play." },
      fr: { name: "Bullpadel Overgrip Pack x3", slug: "bullpadel-overgrip-pack", description: "Pack de 3 surgrips haute absorption. Offre un excellent confort et une bonne gestion de la transpiration." },
      nl: { name: "Bullpadel Overgrip Pack x3", slug: "bullpadel-overgrip-pack", description: "Pak van 3 hoge absorptie overgrips. Biedt uitstekend comfort en zweetbeheer tijdens het spelen." }
    }
  },
  # --- Draft product (not yet published) ---
  {
    brand: "Babolat", base_price_cents: 22990, category: control, status: "draft",
    variants: [
      { name: "Default", sku: "babolat-counter-viper-default", stock_quantity: 0 }
    ],
    translations: {
      en: { name: "Babolat Counter Viper", slug: "babolat-counter-viper", description: "Upcoming control racket from Babolat. Teardrop shape with a wide sweet spot for forgiving shots." },
      fr: { name: "Babolat Counter Viper", slug: "babolat-counter-viper", description: "Prochaine raquette de contrôle Babolat. Forme goutte d'eau avec un large sweet spot pour des frappes plus tolérantes." },
      nl: { name: "Babolat Counter Viper", slug: "babolat-counter-viper", description: "Aankomend controle racket van Babolat. Druppelvorm met een breed sweet spot voor vergevingsgezinde slagen." }
    }
  },
  # --- Archived product (discontinued) ---
  {
    brand: "Head", base_price_cents: 18990, category: power, status: "archived",
    variants: [
      { name: "Default", sku: "head-delta-pro-2024-default", stock_quantity: 1 }
    ],
    translations: {
      en: { name: "Head Delta Pro 2024", slug: "head-delta-pro-2024", description: "Previous generation power racket. Replaced by the 2025 model but still a solid choice at a reduced price." },
      fr: { name: "Head Delta Pro 2024", slug: "head-delta-pro-2024", description: "Raquette de puissance de génération précédente. Remplacée par le modèle 2025 mais reste un choix solide à prix réduit." },
      nl: { name: "Head Delta Pro 2024", slug: "head-delta-pro-2024", description: "Vorige generatie power racket. Vervangen door het 2025-model maar nog steeds een solide keuze voor een verlaagde prijs." }
    }
  }
].each { |data| seed_product(data) }

puts "Seeding users..."

admin = User.find_or_create_by!(email: "admin@padelicense.com") do |u|
  u.password = "password123"
  u.first_name = "Admin"
  u.last_name = "Padelicense"
  u.role = "admin"
end

customers = [
  { email: "sophie.martin@example.com", first_name: "Sophie", last_name: "Martin", password: "password123" },
  { email: "lucas.dubois@example.com", first_name: "Lucas", last_name: "Dubois", password: "password123" },
  { email: "emma.janssen@example.com", first_name: "Emma", last_name: "Janssen", password: "password123" }
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.password = attrs[:password]
    u.first_name = attrs[:first_name]
    u.last_name = attrs[:last_name]
    u.role = "customer"
  end
end

puts "Seeding addresses..."

addresses = customers.map do |customer|
  customer.addresses.first || customer.addresses.create!(
    label: "Home",
    line1: "Rue de la Loi #{rand(1..200)}",
    city: "Bruxelles",
    postal_code: "1000",
    country_iso: "BE",
    default: true
  )
end

puts "Seeding orders..."

# Grab all active product variants for order line items
all_variants = ProductVariant.joins(:product).where(products: { status: "active" }).to_a

def create_seed_order(user:, address:, variants:, status:, created_at:)
  # Pick 1-3 random variants for the order
  items = variants.sample(rand(1..3))

  total = items.sum { |v| (v.price_cents || v.product.base_price_cents) * rand(1..2) }

  order = Order.create!(
    user:,
    status:,
    total_cents: total,
    shipping_address_snapshot: {
      line1: address.line1,
      city: address.city,
      postal_code: address.postal_code,
      country_iso: address.country_iso
    },
    created_at:,
    updated_at: created_at
  )

  items.each do |variant|
    quantity = rand(1..2)
    order.line_items.create!(
      product_variant: variant,
      product_name: I18n.with_locale(:en) { variant.product.name },
      variant_name: variant.name,
      unit_price_cents: variant.price_cents || variant.product.base_price_cents,
      quantity:
    )
  end

  order
end

# --- Orders spread over the last 90 days ---
# Goal: realistic data for dashboard stats (daily/weekly/monthly revenue)

now = Time.current

order_configs = [
  # Today — 4 orders (busy day)
  { status: "paid",      offset: 1.hour.ago },
  { status: "pending",   offset: 30.minutes.ago },
  { status: "paid",      offset: 3.hours.ago },
  { status: "shipped",   offset: 5.hours.ago },

  # Yesterday — 3 orders
  { status: "delivered",  offset: 1.day.ago },
  { status: "paid",       offset: 1.day.ago - 2.hours },
  { status: "shipped",    offset: 1.day.ago - 5.hours },

  # 2 days ago
  { status: "delivered",  offset: 2.days.ago },
  { status: "paid",       offset: 2.days.ago - 3.hours },

  # 3 days ago
  { status: "cancelled",  offset: 3.days.ago },
  { status: "delivered",  offset: 3.days.ago - 1.hour },

  # This week (4-6 days ago)
  { status: "shipped",    offset: 4.days.ago },
  { status: "delivered",  offset: 5.days.ago },
  { status: "paid",       offset: 5.days.ago - 4.hours },
  { status: "delivered",  offset: 6.days.ago },

  # Last week (7-13 days ago)
  { status: "delivered",  offset: 7.days.ago },
  { status: "delivered",  offset: 8.days.ago },
  { status: "cancelled",  offset: 9.days.ago },
  { status: "delivered",  offset: 10.days.ago },
  { status: "shipped",    offset: 11.days.ago },
  { status: "delivered",  offset: 12.days.ago },

  # 2 weeks ago
  { status: "delivered",  offset: 14.days.ago },
  { status: "delivered",  offset: 15.days.ago },
  { status: "cancelled",  offset: 16.days.ago },
  { status: "delivered",  offset: 17.days.ago },

  # 3 weeks ago
  { status: "delivered",  offset: 21.days.ago },
  { status: "delivered",  offset: 22.days.ago },

  # Last month (30-45 days ago)
  { status: "delivered",  offset: 30.days.ago },
  { status: "delivered",  offset: 32.days.ago },
  { status: "cancelled",  offset: 34.days.ago },
  { status: "delivered",  offset: 36.days.ago },
  { status: "delivered",  offset: 38.days.ago },
  { status: "delivered",  offset: 40.days.ago },
  { status: "delivered",  offset: 42.days.ago },

  # 2 months ago (55-70 days ago)
  { status: "delivered",  offset: 55.days.ago },
  { status: "delivered",  offset: 58.days.ago },
  { status: "cancelled",  offset: 60.days.ago },
  { status: "delivered",  offset: 63.days.ago },
  { status: "delivered",  offset: 65.days.ago },
  { status: "delivered",  offset: 68.days.ago },

  # 3 months ago (80-90 days ago)
  { status: "delivered",  offset: 80.days.ago },
  { status: "delivered",  offset: 83.days.ago },
  { status: "delivered",  offset: 85.days.ago },
  { status: "delivered",  offset: 88.days.ago },
  { status: "cancelled",  offset: 90.days.ago }
]

# Also add a few guest orders (no user)
guest_orders = [
  { status: "paid",      offset: 2.hours.ago,  email: "guest.buyer@example.com" },
  { status: "delivered", offset: 4.days.ago,    email: "tourist@example.com" },
  { status: "delivered", offset: 20.days.ago,   email: "one.time@example.com" },
  { status: "cancelled", offset: 45.days.ago,   email: "changed.mind@example.com" }
]

order_configs.each do |config|
  customer = customers.sample
  address = customer.addresses.first || addresses.first

  create_seed_order(
    user: customer,
    address:,
    variants: all_variants,
    status: config[:status],
    created_at: config[:offset]
  )
end

guest_orders.each do |config|
  items = all_variants.sample(rand(1..2))
  total = items.sum { |v| (v.price_cents || v.product.base_price_cents) * rand(1..2) }

  order = Order.create!(
    user: nil,
    guest_email: config[:email],
    status: config[:status],
    total_cents: total,
    shipping_address_snapshot: {
      line1: "Rue du Touriste #{rand(1..50)}",
      city: "Bruxelles",
      postal_code: "1000",
      country_iso: "BE"
    },
    created_at: config[:offset],
    updated_at: config[:offset]
  )

  items.each do |variant|
    order.line_items.create!(
      product_variant: variant,
      product_name: I18n.with_locale(:en) { variant.product.name },
      variant_name: variant.name,
      unit_price_cents: variant.price_cents || variant.product.base_price_cents,
      quantity: rand(1..2)
    )
  end
end

puts "Done!"
puts "  #{Category.count} categories"
puts "  #{Product.count} products (#{Product.active.count} active, #{Product.draft.count} draft, #{Product.archived.count} archived)"
puts "  #{ProductVariant.count} variants (#{ProductVariant.where('stock_quantity < 5').count} low stock, #{ProductVariant.where(stock_quantity: 0).count} out of stock)"
puts "  #{User.count} users (#{User.admin.count} admin, #{User.customer.count} customers)"
puts "  #{Order.count} orders (#{Order.group(:status).count.map { |s, c| "#{c} #{s}" }.join(', ')})"
