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
  product.featured = data[:featured]
  product.status = "active"

  data[:translations].each do |locale, attrs|
    I18n.with_locale(locale) do
      product.name = attrs[:name]
      product.slug = attrs[:slug]
      product.description = attrs[:description]
    end
  end

  product.save!

  unless product.variants.any?
    product.variants.create!(name: "Default", sku: "#{en[:slug]}-default", stock_quantity: 10)
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
    translations: {
      en: { name: "Head Speed Pro", slug: "head-speed-pro", description: "The Head Speed Pro offers exceptional control and a comfortable feel. Perfect for intermediate to advanced players who value precision over power." },
      fr: { name: "Head Speed Pro", slug: "head-speed-pro", description: "La Head Speed Pro offre un contrôle exceptionnel et un confort de jeu remarquable. Parfaite pour les joueurs intermédiaires à avancés qui privilégient la précision." },
      nl: { name: "Head Speed Pro", slug: "head-speed-pro", description: "De Head Speed Pro biedt uitzonderlijke controle en een comfortabel gevoel. Perfect voor gevorderde spelers die precisie verkiezen boven kracht." }
    }
  },
  {
    brand: "Bullpadel", base_price_cents: 34990, category: power, featured: true,
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
    translations: {
      en: { name: "Head Pro S", slug: "head-pro-s-balls", description: "Official World Padel Tour ball. Pressurized for consistent bounce and durability." },
      fr: { name: "Head Pro S", slug: "head-pro-s-balles", description: "Balle officielle du World Padel Tour. Pressurisée pour un rebond constant et une bonne durabilité." },
      nl: { name: "Head Pro S", slug: "head-pro-s-ballen", description: "Officiële World Padel Tour bal. Onder druk gezet voor een consistente stuit en duurzaamheid." }
    }
  },
  {
    brand: "Asics", base_price_cents: 8990, category: shoes, featured: false,
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
  }
].each { |data| seed_product(data) }

puts "Seeding admin user..."

User.find_or_create_by!(email: "admin@padelicense.com") do |u|
  u.password = "password123"
  u.first_name = "Admin"
  u.last_name = "Padelicense"
  u.role = "admin"
end

puts "Done! #{Category.count} categories, #{Product.count} products, #{ProductVariant.count} variants."
