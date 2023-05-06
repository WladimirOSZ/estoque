require 'rails_helper'

describe 'Administrador cadastra items' do
  it 'E vê o formulário de cadastro' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
                sex:1, role: :admin)
    login_as(User.last)

    visit root_path
    click_on 'Itens'
    click_on 'Cadastrar item'

    expect(page).to have_content('Nome')
    expect(page).to have_content('Descrição')
    expect(page).to have_content('Foto')
    expect(page).to have_content('Peso')
    expect(page).to have_content('Largura')
    expect(page).to have_content('Altura')
    expect(page).to have_content('Profundidade')

    expect(page).to have_content('Categorias')
    expect(page).to have_button('Enviar')

  end
end