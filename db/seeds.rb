# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin_user = User.find_or_create_by!(email: "admin@barberia.com") do |user|
  user.name = "Juan Pérez"
  user.password = "password123"
  user.role = "admin"
  user.phone = "+1234567890"
end

puts "Admin user created: #{admin_user.email}"

# Create regular user
regular_user = User.find_or_create_by!(email: "maria@barberia.com") do |user|
  user.name = "María García"
  user.password = "Password123!"
  user.role = "user"
  user.phone = "+0987654321"
end

puts "Regular user created: #{regular_user.email}"
