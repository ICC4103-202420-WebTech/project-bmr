# db/seeds.rb

# Usuarios de prueba
User.find_or_create_by!(email: "professor1@example.com") do |user|
    user.password = "password"
    user.role = "professor"
  end
  
  User.find_or_create_by!(email: "professor2@example.com") do |user|
    user.password = "password"
    user.role = "professor"
  end
  
  User.find_or_create_by!(email: "student1@example.com") do |user|
    user.password = "password"
    user.role = "student"
  end
  
  User.find_or_create_by!(email: "student2@example.com") do |user|
    user.password = "password"
    user.role = "student"
  end
  
  User.find_or_create_by!(email: "student3@example.com") do |user|
    user.password = "password"
    user.role = "student"
  end
  
  puts "Seed data loaded successfully!"
  