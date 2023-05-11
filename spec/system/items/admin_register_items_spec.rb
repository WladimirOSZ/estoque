require 'rails_helper'

describe 'Administrador cadastra items' do
  it 'E vê o formulário de cadastro' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
                sex:1, role: :admin, cpf: '491.150.798.55')
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
    # adiciona categorias

    expect(page).to have_button('Criar Item')
  end

  it 'E preenche todos os campos' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
    
    Category.create!(name: 'Celulares')
    Category.create!(name: 'Eletrônicos')
    Category.create!(name: 'Móveis')
    Category.create!(name: 'Eletrodomésticos')

    login_as(User.last)

    visit root_path
    click_on 'Itens'
    click_on 'Cadastrar item'

    fill_in 'Nome', with: 'Celular'
    fill_in 'Descrição', with: 'Celular novo'
    fill_in 'Peso', with: '10'
    fill_in 'Largura', with: '20'
    fill_in 'Altura', with: '20'
    fill_in 'Profundidade', with: '5'

    # attach_file 'Foto', Rails.root.join('spec', 'support', 'celular.jpg')
    check 'Celulares'
    check 'Eletrônicos'
    click_on 'Criar Item'

    expect(page).to have_content('Item cadastrado com sucesso')
    expect(page).to have_content('Celular')

  end
end