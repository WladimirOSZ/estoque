require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E visualiza um produto' do
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(User.last)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Televisões')
    Category.create!(name: 'Eletrônicos')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 4)
    ItemCategory.create!(item_id: first_item.id, category_id: 5)

    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    second_item = Item.create!(name: 'Iphone 15.5 XS',
                  description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                  photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)
    
    ItemCategory.create!(item_id: second_item.id, category_id: 1)
    ItemCategory.create!(item_id: second_item.id, category_id: 3)
    

    #act
    visit root_path
    click_on 'Itens'
    within("div#item-#{first_item.code}") do
      click_on 'Ver item'
    end

    
    expect(page).to have_content('Caneca Botafogo Cerâmica')
    expect(page).to have_content('Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.')
    expect(page).to have_css('img[src*="caneca-botafogo.jpg"]')
    expect(page).to have_content('Peso: 300g')
    expect(page).to have_content('Largura: 10cm')
    expect(page).to have_content('Altura: 10cm')
    expect(page).to have_content('Profundidade: 10cm')
    expect(page).to have_content('Código: ABCDE12345')
    within("div#categories") do
      expect(page).to have_content('Cozinha')
      expect(page).to have_content('Esporte')
    end
  end

  it 'E não há itens cadastrados' do
    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Nenhum item cadastrado')
  end

end