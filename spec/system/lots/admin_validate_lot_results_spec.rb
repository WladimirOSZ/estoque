require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Administrador a seção de lotes finalizados' do
  it 'E não há lotes finalizados' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                          sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    expect(page).to have_content('Não há lotes finalizados')
  end

  it 'E vê todos os lotes finalizados' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')


    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
          minimum_value: 1000, minimum_difference: 100,
          created_by_id: admin_1.id, approved_by_id: admin_2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
            minimum_value: 1000, minimum_difference: 100,
            created_by_id: admin_1.id, approved_by_id: admin_2.id)

            
    travel_to Time.zone.local(2023, 05, 18, 01, 15, 00) do
      first_lot.end_date =  1.seconds.from_now
      first_lot.save!

      second_lot.end_date =  1.seconds.from_now
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
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')


    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
          minimum_value: 1000, minimum_difference: 100,
          created_by_id: admin_1.id, approved_by_id: admin_2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
            minimum_value: 1000, minimum_difference: 100,
            created_by_id: admin_1.id, approved_by_id: admin_2.id)

            
    travel_to Time.zone.local(2023, 05, 18, 01, 15, 00) do
      first_lot.end_date =  1.seconds.from_now
      first_lot.save!

      second_lot.end_date =  1.seconds.from_now
      second_lot.save!
    end

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end

    within("div#action_card_footer") do
      click_on 'Cancelar lote'
    end

    expect(page).to have_content('Status do lote atualizado com sucesso!')
    within("div#lots_canceled") do
      expect(page).to have_content('ABC123')
    end

    within("div#lots_waiting") do
      expect(page).not_to have_content('ABC123')
    end
  end

  it 'E aprova um lote' do
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
                sex:1, role: :user, cpf: '111.222.333.44')
    
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')


    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
          minimum_value: 1000, minimum_difference: 100,
          created_by_id: admin_1.id, approved_by_id: admin_2.id)

    second_lot = Lot.new(code: 'BCA321', start_date: '2023-05-01 15:30:00',
            minimum_value: 1000, minimum_difference: 100,
            created_by_id: admin_1.id, approved_by_id: admin_2.id)

            
    travel_to Time.zone.local(2023, 05, 18, 01, 15, 00) do
      first_lot.end_date =  10.seconds.from_now
      first_lot.save!
      Bid.create!(lot_id: first_lot.id, user_id: 1, value: 2000)

      second_lot.end_date =  1.seconds.from_now
      second_lot.save!
    end

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                        description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                        photo: image,
                        weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

    

    visit root_path
    within('nav') do
      click_on 'Lotes finalizados'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end

    within("div#action_card_footer") do
      click_on 'Finalizar lote'
    end

    expect(page).to have_content('Status do lote atualizado com sucesso!')
    within("div#lots_approved") do
      expect(page).to have_content('ABC123')
    end

    within("div#lots_waiting") do
      expect(page).not_to have_content('ABC123')
    end
  end

end
