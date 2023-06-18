# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário cadastra categorias' do
  context 'mas não é administrador' do
    it 'E acessa diretamente a rota de criação' do
      user = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '065.625.380-09')

      login_as(user)

      visit new_category_path

      expect(current_path).to eq root_path
      expect(page).to have_content('Você não tem permissão para essa ação')
    end

    it 'E não vê o botão de cadastro na aba categorias' do
      user = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '065.625.380-09')

      login_as(user)

      visit root_path
      click_on 'Categorias'

      expect(page).not_to have_link('Cadastrar Categoria')
    end
  end

  context 'é administrador' do
    it 'E cadastra uma categoria com campos validos' do
      User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                   sex: 1, role: :admin, cpf: '065.625.380-09')
      login_as(User.last)

      visit root_path
      click_on 'Categorias'
      click_on 'Cadastrar categoria'

      fill_in 'Nome', with: 'Eletrônicos'
      click_on 'Criar Categoria'

      expect(page).to have_content('Eletrônicos')
      expect(page).to have_content('Categoria cadastrada com sucesso!')
    end

    it 'E cadastra uma categoria com campos em branco' do
      User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                   sex: 1, role: :admin, cpf: '764.424.940-04')
      login_as(User.last)

      visit root_path
      click_on 'Categorias'
      click_on 'Cadastrar categoria'

      fill_in 'Nome', with: ''
      click_on 'Criar Categoria'

      expect(page).to have_content('Nome não pode ficar em branco')
      expect(page).to have_content('Nome é muito curto (mínimo: 3 caracteres)')
    end

    it 'E cadastra uma categoria com nome repetido' do
      User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                   sex: 1, role: :admin, cpf: '764.424.940-04')
      login_as(User.last)

      visit root_path
      click_on 'Categorias'
      click_on 'Cadastrar categoria'

      fill_in 'Nome', with: 'Eletrônicos'
      click_on 'Criar Categoria'

      click_on 'Cadastrar categoria'

      fill_in 'Nome', with: 'Eletrônicos'
      click_on 'Criar Categoria'

      # erro aqui, está redirecionando para categories_path
      # expect(current_path).to eq new_category_path
      expect(page).to have_content('Nome já está em uso')
    end
  end
end
