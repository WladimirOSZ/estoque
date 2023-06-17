require 'rails_helper'

describe 'Usuário faz login' do
  it 'com email e senha válidos' do
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com',
                 password: 'password', sex: 1, role: :user, cpf: '065.625.380-09')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'user@gmail.com'
    fill_in 'Senha', with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content('Login efetuado com sucesso!')
    expect(page).to have_content('Wladimir Oliveira')
    expect(page).to have_button('Sair')
    expect(page).not_to have_link('Entrar')
  end

  it 'com email e senha inválidos' do
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com',
                 password: 'password', sex: 1, role: :user, cpf: '065.625.380-09')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'user@gmail.com'
    fill_in 'Senha', with: '123456'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).not_to have_content('Wladimir Oliveira')
    expect(page).not_to have_button('Sair')
    expect(page).to have_link('Entrar')
  end
end
