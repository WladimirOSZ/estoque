require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E não há itens cadastrados' do
    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Nenhum item cadastrado')
  end

  it 'E visualiza um item' do
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                 sex: 1, role: :user, cpf: '065.625.380-09')
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
    within('div#categories') do
      expect(page).to have_content('Cozinha')
      expect(page).to have_content('Esporte')
    end
  end

  it 'E o item não está em um lote' do
    user_admin = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                              sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(user_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                              description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                              photo: image,
                              weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    within("div#item-#{first_item.code}") do
      click_on 'Ver item'
    end

    within('div#info-item') do
      expect(page).to have_content('Este item ainda não está em nenhum lote')
    end
  end

  it 'E o item está em um lote, mas o lote ainda não foi disponibilizado para os usuários' do
    user_1 = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(user_1)

    user_admin_1 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                                sex: 1, role: :admin, cpf: '621.830.060-99')
    user_admin_2 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                                sex: 1, role: :admin, cpf: '259.857.290-44')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                              description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                              photo: image,
                              weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 2)

    ItemLot.create!(item_id: first_item.id, lot_id: Lot.last.id)

    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    within("div#item-#{first_item.code}") do
      click_on 'Ver item'
    end

    within('div#info-item') do
      expect(page).to have_content('Este item ainda não está em nenhum lote')
    end
  end

  it 'E o item está em um lote, mas não há lances até o momento' do
    user_1 = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(user_1)

    user_admin_1 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                                sex: 1, role: :admin, cpf: '621.830.060-99')
    user_admin_2 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                                sex: 1, role: :admin, cpf: '259.857.290-44')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                              description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                              photo: image,
                              weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 2, approved_by_id: 3)

    ItemLot.create!(item_id: first_item.id, lot_id: Lot.last.id)

    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    within("div#item-#{first_item.code}") do
      click_on 'Ver item'
    end

    within('div#info-item') do
      expect(page).to have_content('Item do lote ABC123')
      expect(page).to have_content('Este item ainda não possui lances, seja o primeiro!')
      expect(page).to have_content('Lance mínimo: R$ 1.000,00')
      expect(page).to have_content('Diferença mínima entre lances: R$ 100,00')
      expect(page).to have_content('Estado do lote: Aberto')
      expect(page).to have_content('O lote fecha em: 1 dia')
      expect(page).to have_link('Ver lote')
    end
  end
end
