# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Customer.create!(first_name: "John", last_name: "Wick", email: "email1@gmail.com", address: "New York")
Customer.create!(first_name: "John", last_name: "Constantine", email: "email2@gmail.com", address: "Las Angeles")
Customer.create!(first_name: "Johnny", last_name: "Utah", email: "email3@gmail.com", address: "Venice Beach")
Customer.create!(first_name: "Jonathon", last_name: "Harker", email: "email4@gmail.com", address: "Translyvania")
Customer.create!(first_name: "Johnny", last_name: "Mnemonic", email: "email5@gmail.com", address: "Toronto")

Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
Tea.create!(title: "Black", description: "It's kinda black, I guess.", temperature: 120, brew_time: 2)
Tea.create!(title: "Sensha Green", description: "It's actually green.", temperature: 105, brew_time: 2)
Tea.create!(title: "Citrus", description: "Probably not a tea.", temperature: 110, brew_time: 3)
Tea.create!(title: "Jasmine", description: "Is it pink or green?", temperature: 105, brew_time: 1)
