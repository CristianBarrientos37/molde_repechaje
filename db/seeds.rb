# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "Cleaning database..."
User.destroy_all
Employee.destroy_all
Schedule.destroy_all

puts "Creating admin..."
admin = User.create!(
  name: "Administrador",
  email: 'administrador@mail.com',
  password: 'Abc123#',
  user_type: 'administrator'
)

Employee.create!(
  name: admin.name,
  birth_date: Faker::Date.birthday(min_age: 30, max_age: 60),
  position: 'administrator',
  hire_date: Faker::Date.backward(days: 365 * 5),
  user: admin
)

puts "Creating managers..."
3.times do |i|
  manager = User.create!(
    name: Faker::Name.name,
    email: "manager#{i+1}@mail.com",
    password: 'Abc123#',
    user_type: 'manager'
  )

  Employee.create!(
    name: manager.name,
    birth_date: Faker::Date.birthday(min_age: 25, max_age: 60),
    position: 'manager',
    hire_date: Faker::Date.backward(days: 365 * 5),
    user: manager
  )
end

puts "Creating employees..."
10.times do |i|
  employee = User.create!(
    name: Faker::Name.name,
    email: "employee#{i+1}@mail.com",
    password: 'Abc123#',
    user_type: 'employee'
  )

  Employee.create!(
    name: employee.name,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
    position: 'employee',
    hire_date: Faker::Date.backward(days: 365 * 5),
    user: employee
  )
end

puts "Creating schedules..."
Employee.all.each do |employee|
  Schedule.create!(
    name: "Horario #{['Mañana', 'Tarde'].sample}",
    description: 'Horario de trabajo asignado',
    shift_type: ['morning', 'evening'].sample,
    employee: employee,
    user: admin
  )
end

puts "Seeds completed!"