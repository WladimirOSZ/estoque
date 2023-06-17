require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E não há itens cadastrados' do
    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    expect(page).to have_content('Nenhum item cadastrado')
  end

  it 'E não vê botão de cadastrar item' do
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                 sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(User.last)
    visit root_path
    click_on 'Itens'

    expect(page).not_to have_content('Cadastrar item')
  end

  it 'E vê todos os itens cadastrados' do
    # Arrange
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                 sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(User.last)

    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    item_iphone = Item.create!(name: 'Iphone 15.5 XS',
                               description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                               photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    image = fixture_file_upload(Rails.root.join('spec/support/images/s20.jpg'), 'imagejpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('99999CAFES')
    item_samsung = Item.create!(name: 'Samsung Galaxy S20',
                                description: 'O Samsung Galaxy S20 é um smartphone Android com características inovadoras que o tornam uma excelente opção para qualquer tipo de utilização. A tela de 6.2 polegadas coloca esse Samsung no topo de sua categoria. A resolução também é alta: 3200x1440 pixel. As funcionalidades oferecidas pelo Samsung Galaxy S20 são muitas e top de linha. Começando pelo LTE 5G que permite a transferência de dados e excelente navegação na internet.',
                                photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Itens')
    within('div#item-IPHON12345') do
      expect(page).to have_content('Iphone 15.5 XS')
    end
    within('div#item-99999CAFES') do
      expect(page).to have_content('Samsung Galaxy S20')
    end
  end

  it 'E os itens tem a descrição encurtada' do
    # Arrange
    User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                 sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(User.last)

    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    item_iphone = Item.create!(name: 'Iphone 15.5 XS',
                               description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                               photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Itens')
    within('div#item-IPHON12345') do
      expect(page).to have_content('O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bi...')
    end
  end

  it 'E vê todos os items de um lote' do
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
    item_caneca = Item.create!(name: 'Caneca Botafogo Cerâmica',
                               description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                               photo: image,
                               weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    image = fixture_file_upload(Rails.root.join('spec/support/images/s20.jpg'), 'imagejpeg')

    allow(SecureRandom).to receive(:alphanumeric).and_return('99999CAFES')
    item_samsung = Item.create!(name: 'Samsung Galaxy S20',
                                description: 'O Samsung Galaxy S20 é um smartphone Android com características inovadoras que o tornam uma excelente opção para qualquer tipo de utilização. A tela de 6.2 polegadas coloca esse Samsung no topo de sua categoria. A resolução também é alta: 3200x1440 pixel. As funcionalidades oferecidas pelo Samsung Galaxy S20 são muitas e top de linha. Começando pelo LTE 5G que permite a transferência de dados e excelente navegação na internet.',
                                photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemCategory.create!(item_id: item_caneca.id, category_id: 2)
    ItemCategory.create!(item_id: item_caneca.id, category_id: 3)

    ItemCategory.create!(item_id: item_samsung.id, category_id: 1)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: 2, approved_by_id: 3)

    ItemLot.create!(item_id: item_caneca.id, lot_id: lot.id)
    ItemLot.create!(item_id: item_samsung.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{lot.code}") do
      click_on 'Ver lote'
    end

    expect(page).to have_content('Items do lote:')
    within('div#item-ABCDE12345') do
      expect(page).to have_content('Caneca Botafogo Cerâmica')
      expect(page).to have_link('Visualizar item')
    end
    within('div#item-99999CAFES') do
      expect(page).to have_content('Samsung Galaxy S20')
      expect(page).to have_link('Visualizar item')
    end
  end
end
