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

User.create!(name: 'João Silva',email: 'joao_cc@leilaodogalpao.com.br', password: 'password',
  sex:1, role: :admin, cpf: '111.222.333.44')

# user
User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
            sex:1, role: :user, cpf: '491.150.798.56')

# categorySeeder

Category.create!(name: 'Celulares')
Category.create!(name: 'Televisões')
Category.create!(name: 'Video Games')
Category.create!(name: 'Eletrônicos')


# lotSeeder

Lot.create!(code: 'ABC12345', start_date: '2021-05-01', end_date: '2023-05-30 15:30:00',
          mininum_value: 100, mininum_difference: 10,
          created_by_id: 2, approved_by_id: 3)

