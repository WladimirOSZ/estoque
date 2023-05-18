require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Usuário dá um lance' do
  it 'E vê o maior lance' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    user_2 = User.create!(name: 'Joãozinho da Silva',email: 'segundouser@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '222.111.333.44')

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_1.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)
    
    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    Bid.create!(value: 1001, user_id: user_2.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      expect(page).to have_content('Status do lote: Aberto')
      expect(page).to have_content('Lance mais alto até o momento: R$ 1.001,00')
      expect(page).to have_content('Lance mínimo: R$ 1.102,00')
    end


  end

  it 'E não há lances' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_2.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)
    
    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      expect(page).to have_content('Status do lote: Aberto')
      expect(page).to have_content('Lance mais alto até o momento: Não há lances')
      expect(page).to have_content('Lance mínimo: R$ 1.000,00')
    end
  end

  it 'E faz um lance menor do que o valor mínimo do lote' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_2.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      fill_in 'Digite seu lance:', with: 500
      click_on 'Dar lance'
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    within("div#lot-ABC123") do
      expect(page).to have_content('Valor deve ser maior que o valor mínimo do lote')
    end

  end

  it 'E faz um lance menor do que o valor do último lance mais as diferença mínima' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    user_2 = User.create!(name: 'Joãozinho da Silva',email: 'segundouser@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '222.111.333.44')

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_2.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    Bid.create!(value: 1001, user_id: user_2.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      fill_in 'Digite seu lance:', with: 1005
      click_on 'Dar lance'
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    within("div#lot-ABC123") do
      expect(page).to have_content('Valor deve ser maior que o último lance mais a diferença mínima')
    end

  end

  it 'E faz um lance válido' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_2.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)
    
    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      fill_in 'Digite seu lance:', with: 1001
      click_on 'Dar lance'
    end
  end

  it 'E faz um lance após o fechamento do lote' do
    user_1 = User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(user_1)

    admin_1 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')
    admin_2 = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.10')

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: admin_2.id)
    
    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: admin_1.id, approved_by_id: admin_2.id)
    
    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      click_on 'Ver lote'
    end

    within("div#lot-ABC123") do
      fill_in 'Digite seu lance:', with: 1001

      travel 3.days do
        click_on 'Dar lance'
      end
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    # expect(page).to have_content('já fechou. Não é mais possível dar lances')

  end

end