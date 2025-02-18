p "1. Seeding admin"

Admin.find_or_create_by(email_address: "admin@e.com") do |u|
  u.full_name = "admin"
  u.password = "password123"
end