# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "iniciando seed"
 FactoryBot.create(:user)
 FactoryBot.create(:classroom)
 administrator = FactoryBot.create(:administrator, user: FactoryBot.create(:user))
 FactoryBot.create(:balance)

 admin_user = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  cpf: "12345678901",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.now
)

Administrator.create!(user: admin_user)

balance = admin_user.balance
balance.current_balance = 90000
balance.save
puts "finalizou seed"
