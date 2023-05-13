require 'rails_helper'

describe 'Administrador cadastra items' do

  it 'E vê o botão de cadastrar item' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
    login_as(User.last)

    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Cadastrar item')
  end

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
    Category.create!(name: 'Decoração')
    Category.create!(name: 'Esporte')

    login_as(User.last)

    visit root_path
    click_on 'Itens'
    click_on 'Cadastrar item'

    fill_in 'Nome', with: 'Caneca Botafogo Cerâmica'
    fill_in 'Descrição', with: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.'
    fill_in 'Peso', with: '10'
    fill_in 'Largura', with: '20'
    fill_in 'Altura', with: '20'
    fill_in 'Profundidade', with: '30'
    attach_file 'Foto', Rails.root.join('spec/support/images/caneca-botafogo.jpg')

    # attach_file 'Foto', Rails.root.join('spec', 'support', 'celular.jpg')
    check 'Decoração'
    check 'Esporte'
    click_on 'Criar Item'

    expect(page).to have_content('Item cadastrado com sucesso')
    expect(page).to have_content('Caneca Botafogo Cerâmica')
    expect(page).to have_css('img[src*="caneca-botafogo.jpg"]')
    expect(page).to have_content('Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.')
    expect(page).to have_content('Peso: 10g')
    expect(page).to have_content('Largura: 20cm')
    expect(page).to have_content('Altura: 20cm')
    expect(page).to have_content('Profundidade: 30cm')
    within('div#categories') do
      expect(page).to have_content('Decoração')
      expect(page).to have_content('Esporte')
    end

    expect(page).to have_link('Voltar')
  end
end