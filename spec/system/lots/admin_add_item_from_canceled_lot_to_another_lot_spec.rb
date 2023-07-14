require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Administrador cadastra items de um lote cancelado em outro lote' do
  it 'E visualiza o item' do
    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)
    user1 = create(:user)
    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = create(:item, user: admin1)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)
      Bid.create!(lot_id: first_lot.id, user_id: user1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin1.id)

    login_as(admin1)
    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{second_lot.code}") do
      click_on 'Adicionar items'
    end

    expect(page).to have_content('dicionar - ABCDE12345')
  end

  it 'E adiciona em outro lote' do
    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)
    create(:user)
    first_item = nil
    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = create(:item, user: admin1)
      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin1.id)
    login_as(admin1)
    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{second_lot.code}") do
      click_on 'Adicionar items'
    end

    check 'Adicionar - ABCDE12345'

    within('div#form-top') do
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Lote atualizado com sucesso!')
    expect(page).to have_content(first_item.name)
  end

  it 'E ainda vê o item através do primeiro lote' do
    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)
    user1 = create(:user)
    first_item = nil
    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      first_item = create(:item, user: admin1)
      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)
      Bid.create!(lot_id: first_lot.id, user_id: user1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin1.id)

    ItemLot.create!(lot_id: second_lot.id, item_id: Item.last.id)

    login_as(admin1)
    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end
    expect(page).to have_content(first_item.name)
  end

  it 'E acessa o novo lote através do item' do
    admin1 = create(:user, :admin)
    admin2 = create(:user, :second_admin)
    user1 = create(:user)
    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = create(:item, user: admin1)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

      Bid.create!(lot_id: first_lot.id, user_id: user1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin1.id)

    ItemLot.create!(lot_id: second_lot.id, item_id: Item.last.id)

    login_as(admin1)
    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    within("div#item-#{Item.last.code}") do
      click_on 'Ver item'
    end

    click_on 'Ver lote'

    expect(page).to have_content('BCA321')
  end
end
