require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Usuário dá um lance' do
  it 'E vê o maior lance' do
    user1 = create(:user)
    login_as(user1)

    user2 = create(:user, :second_user)
    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    Bid.create!(value: 1001, user_id: user2.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      expect(page).to have_content('Status do lote: Aberto')
      expect(page).to have_content('Lance mais alto até o momento: R$ 1.001,00')
      expect(page).to have_content('Lance mínimo: R$ 1.102,00')
    end
  end

  it 'E não há lances' do
    user1 = create(:user)
    login_as(user1)

    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      expect(page).to have_content('Status do lote: Aberto')
      expect(page).to have_content('Lance mais alto até o momento: Não há lances')
      expect(page).to have_content('Lance mínimo: R$ 1.000,00')
    end
  end

  it 'E faz um lance menor do que o valor mínimo do lote' do
    user1 = create(:user)
    login_as(user1)

    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      fill_in 'Digite seu lance:', with: 500
      click_on 'Dar lance'
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    within('div#lot-ABC123') do
      expect(page).to have_content('Valor deve ser maior que o valor mínimo do lote')
    end
  end

  it 'E faz um lance menor do que o valor do último lance mais as diferença mínima' do
    user1 = create(:user)
    login_as(user1)

    user2 = create(:user, :second_user)

    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    Bid.create!(value: 1001, user_id: user2.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      fill_in 'Digite seu lance:', with: 1005
      click_on 'Dar lance'
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    within('div#lot-ABC123') do
      expect(page).to have_content('Valor deve ser maior que o último lance mais a diferença mínima')
    end
  end

  it 'E faz um lance válido' do
    user1 = create(:user)
    login_as(user1)

    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      fill_in 'Digite seu lance:', with: 1001
      click_on 'Dar lance'
    end
  end

  it 'E faz um lance após o fechamento do lote' do
    user1 = create(:user)
    login_as(user1)

    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Cozinha')
    Category.create!(name: 'Esporte')

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemCategory.create!(item_id: first_item.id, category_id: 2)
    ItemCategory.create!(item_id: first_item.id, category_id: 3)

    lot = Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.day.from_now,
                      minimum_value: 1000, minimum_difference: 100,
                      created_by_id: admin1.id, approved_by_id: admin2.id)

    ItemLot.create!(item_id: first_item.id, lot_id: lot.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    within('div#lot-ABC123') do
      fill_in 'Digite seu lance:', with: 1001

      travel 3.days do
        click_on 'Dar lance'
      end
    end

    expect(page).to have_content('Não foi possível fazer o lance')
    # expect(page).to have_content('já fechou. Não é mais possível dar lances')
  end
end
