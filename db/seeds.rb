return if Rails.env.test?

puts "Seeding categories..."

rackets = Category.find_or_create_by!(slug: "rackets") do |c|
  c.name = "Rackets"
  c.description = "Padel rackets for all levels"
  c.position = 0
end

control = Category.find_or_create_by!(slug: "control-rackets") do |c|
  c.name = "Control"
  c.description = "Rackets focused on precision and touch"
  c.parent = rackets
  c.position = 0
end

power = Category.find_or_create_by!(slug: "power-rackets") do |c|
  c.name = "Power"
  c.description = "Rackets focused on power and smash"
  c.parent = rackets
  c.position = 1
end

balls = Category.find_or_create_by!(slug: "balls") do |c|
  c.name = "Balls"
  c.description = "Official padel balls"
  c.position = 1
end

shoes = Category.find_or_create_by!(slug: "shoes") do |c|
  c.name = "Shoes"
  c.description = "Padel shoes for all surfaces"
  c.position = 2
end

accessories = Category.find_or_create_by!(slug: "accessories") do |c|
  c.name = "Accessories"
  c.description = "Grips, bags, and more"
  c.position = 3
end

puts "Seeding products..."

products_data = [
  {
    name: "Head Speed Pro",
    slug: "head-speed-pro",
    brand: "Head",
    base_price_cents: 24990,
    category: control,
    featured: true,
    description: "The Head Speed Pro offers exceptional control and a comfortable feel. Perfect for intermediate to advanced players who value precision over power."
  },
  {
    name: "Bullpadel Vertex 04",
    slug: "bullpadel-vertex-04",
    brand: "Bullpadel",
    base_price_cents: 34990,
    category: power,
    featured: true,
    description: "Top-tier power racket used by professional players. Diamond shape with a high balance for maximum smash power."
  },
  {
    name: "Adidas Metalbone",
    slug: "adidas-metalbone",
    brand: "Adidas",
    base_price_cents: 29990,
    category: power,
    featured: false,
    description: "The Metalbone combines carbon fiber construction with an aggressive diamond shape. A favorite among competitive players."
  },
  {
    name: "Nox AT10 Genius",
    slug: "nox-at10-genius",
    brand: "Nox",
    base_price_cents: 19990,
    category: control,
    featured: false,
    description: "Agustin Tapia's signature racket. Round shape with a soft touch, ideal for players who rely on control and placement."
  },
  {
    name: "Wilson Bela Pro v2",
    slug: "wilson-bela-pro-v2",
    brand: "Wilson",
    base_price_cents: 27990,
    category: control,
    featured: true,
    description: "Fernando Belasteguin's choice. Hybrid shape offering a perfect balance between control and power."
  },
  {
    name: "Head Pro S",
    slug: "head-pro-s-balls",
    brand: "Head",
    base_price_cents: 699,
    category: balls,
    featured: false,
    description: "Official World Padel Tour ball. Pressurized for consistent bounce and durability."
  },
  {
    name: "Asics Gel-Padel Pro 5",
    slug: "asics-gel-padel-pro-5",
    brand: "Asics",
    base_price_cents: 8990,
    category: shoes,
    featured: false,
    description: "Lightweight padel shoe with GEL cushioning. Herringbone outsole for excellent grip on all court surfaces."
  },
  {
    name: "Bullpadel Overgrip Pack x3",
    slug: "bullpadel-overgrip-pack",
    brand: "Bullpadel",
    base_price_cents: 890,
    category: accessories,
    featured: false,
    description: "Pack of 3 high-absorption overgrips. Provides excellent comfort and sweat management during play."
  }
]

products_data.each do |data|
  product = Product.find_or_create_by!(slug: data[:slug]) do |p|
    p.name = data[:name]
    p.brand = data[:brand]
    p.base_price_cents = data[:base_price_cents]
    p.category = data[:category]
    p.featured = data[:featured]
    p.description = data[:description]
    p.status = "active"
  end

  unless product.variants.any?
    product.variants.create!(name: "Default", sku: "#{data[:slug]}-default", stock_quantity: 10)
  end
end

puts "Seeding admin user..."

User.find_or_create_by!(email: "admin@padelicense.com") do |u|
  u.password = "password123"
  u.first_name = "Admin"
  u.last_name = "Padelicense"
  u.role = "admin"
end

puts "Done! Created #{Category.count} categories, #{Product.count} products, #{ProductVariant.count} variants."
