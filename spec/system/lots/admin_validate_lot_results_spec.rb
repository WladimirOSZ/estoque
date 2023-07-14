require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Administrador a seção de lotes finalizados' do
  it 'E não há lotes finalizados' do
    admin1 = create(:user, :admin)

    login_as(admin1)
    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    expect(page).to have_content('Não há lotes finalizados')
  end

  it 'E vê todos os lotes finalizados' do
    admin1 = create(:user, :admin)

    login_as(admin1)

    admin2 = create(:user, :second_admin)

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
                         minimum_value: 1000, minimum_difference: 100,
                         created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 1.second.from_now
      first_lot.save!

      second_lot.end_date = 1.second.from_now
      second_lot.save!
    end

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    expect(page).to have_content('ABC123')
    expect(page).to have_content('BCA321')
  end

  it 'E reprova um lote' do
    admin1 = create(:user, :admin)

    login_as(admin1)

    admin2 = create(:user, :second_admin)

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
                         minimum_value: 1000, minimum_difference: 100,
                         created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 1.second.from_now
      first_lot.save!

      second_lot.end_date = 1.second.from_now
      second_lot.save!
    end

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end

    within('div#action_card_footer') do
      click_on 'Cancelar lote'
    end

    expect(page).to have_content('Status do lote atualizado com sucesso!')
    within('div#lots_canceled') do
      expect(page).to have_content('ABC123')
    end

    within('div#lots_waiting') do
      expect(page).not_to have_content('ABC123')
    end
  end

  it 'E aprova um lote' do
    create(:user)

    admin1 = create(:user, :admin)

    login_as(admin1)

    admin2 = create(:user, :second_admin)

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin1.id, approved_by_id: admin2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
                         minimum_value: 1000, minimum_difference: 100,
                         created_by_id: admin1.id, approved_by_id: admin2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!
      Bid.create!(lot_id: first_lot.id, user_id: 1, value: 2000)

      second_lot.end_date = 1.second.from_now
      second_lot.save!
    end

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end

    within('div#action_card_footer') do
      click_on 'Finalizar lote'
    end

    expect(page).to have_content('Status do lote atualizado com sucesso!')
    within('div#lots_approved') do
      expect(page).to have_content('ABC123')
    end

    within('div#lots_waiting') do
      expect(page).not_to have_content('ABC123')
    end
  end
end
