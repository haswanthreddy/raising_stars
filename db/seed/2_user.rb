p "2. Seeding user"

User.find_or_create_by(email_address: "user@e.com") do |u|
  u.full_name = "User"
  u.password = "password123"
end