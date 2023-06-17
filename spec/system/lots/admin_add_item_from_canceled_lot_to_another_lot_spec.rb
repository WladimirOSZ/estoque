require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Administrador cadastra items de um lote cancelado em outro lote' do
  it 'E visualiza o item' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin_1.id, approved_by_id: admin_2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                                description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                                photo: image,
                                weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin_1.id)

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
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin_1.id, approved_by_id: admin_2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                                description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                                photo: image,
                                weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

      # Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin_1.id)

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
    expect(page).to have_content('Caneca Botafogo Cerâmica')
  end

  it 'E ainda vê o item através do primeiro lote' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin_1.id, approved_by_id: admin_2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                                description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                                photo: image,
                                weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin_1.id)

    ItemLot.create!(lot_id: second_lot.id, item_id: Item.last.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{first_lot.code}") do
      click_on 'Ver lote'
    end

    expect(page).to have_content('Caneca Botafogo Cerâmica')
  end

  it 'E acessa o novo lote através do item' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin_1.id, approved_by_id: admin_2.id)

    travel_to Time.zone.local(2023, 0o5, 18, 0o1, 15, 0o0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                                description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                                photo: image,
                                weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)

      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 2000)
    end

    first_lot.update(status: :canceled)
    first_lot.item_lot.update_all(canceled: true)

    second_lot = Lot.create!(code: 'BCA321', start_date: 1.day.from_now, end_date: 5.days.from_now,
                             minimum_value: 1000, minimum_difference: 100,
                             created_by_id: admin_1.id)

    ItemLot.create!(lot_id: second_lot.id, item_id: Item.last.id)

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
