# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário faz cadastro' do
  it 'e vê o formulário de cadastro' do
    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    click_on 'Cadastrar-se'

    expect(page).to have_content('Cadastro')
    expect(page).to have_content('Nome')
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Confirme sua senha')
    # expect(page).to have_content('Sexo')
    # expect(page).to have_content('CPF')
    # expect(page).to have_content('Data de Nascimento')
  end
end
