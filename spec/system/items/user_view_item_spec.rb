require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E não há itens cadastrados' do
    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Nenhum item cadastrado')
  end

  it 'E visualiza um item' do
    user = create(:user)
    login_as(User.last)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Televisões')
    Category.create!(name: 'Eletrônicos')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: user)

    ItemCategory.create!(item_id: first_item.id, category_id: 4)
    ItemCategory.create!(item_id: first_item.id, category_id: 5)

    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    second_item = create(:item, user: user)

    ItemCategory.create!(item_id: second_item.id, category_id: 1)
    ItemCategory.create!(item_id: second_item.id, category_id: 3)

    visit root_path
    click_on 'Itens'
    within("div#item-#{first_item.code}") do
      click_on 'Ver item'
    end

    expect(page).to have_content(first_item.name)
    expect(page).to have_content(first_item.description)
    expect(page).to have_content("Peso: #{first_item.weight}g")
    expect(page).to have_content("Largura: #{first_item.width}cm")
    expect(page).to have_content("Altura: #{first_item.height}cm")
    expect(page).to have_content("Profundidade: #{first_item.depth}cm")
    expect(page).to have_content('Código: ABCDE12345')
    within('div#categories') do
      expect(page).to have_content('Cozinha')
      expect(page).to have_content('Esporte')
    end
  end

  it 'E o item não está em um lote' do
    admin1 = User.create!(name: 'Wladimir Oliveira', email: 'user@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '065.625.380-09')
    login_as(admin1)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

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
    user1 = create(:user)
    login_as(user1)

    create(:user, :admin)
    create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: user1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
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
    user1 = create(:user)
    login_as(user1)

    create(:user, :admin)
    create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: user1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
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
