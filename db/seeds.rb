# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# userSeeder
# admin
User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
            sex:1, role: :admin, cpf: '491.150.798.55')
# user
User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
            sex:1, role: :user, cpf: '491.150.798.56')

# categorySeeder

Category.create!(name: 'Celulares')
Category.create!(name: 'Televisões')
Category.create!(name: 'Video Games')
Category.create!(name: 'Eletrônicos')

