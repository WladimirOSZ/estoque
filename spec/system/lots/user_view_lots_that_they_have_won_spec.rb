# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário visualiza leilão que ganhou' do
  it 'E não ganhou nenhum' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')

    login_as(user_1)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    expect(page).to have_content('Você não ganhou nenhum leilão. Caso tenha vencido, aguarde um administrador validar o lote para ele aparecer nesta tela. Este processo pode levar até 24 horas.')
  end

  it 'E venceu um lote sendo o único lance' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')
    login_as(user_1)

    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    first_lot = Lot.new(code: 'ABC123', start_date: '2023-05-01 15:30:00',
                        minimum_value: 1000, minimum_difference: 100,
                        created_by_id: admin_1.id)

    travel_to Time.zone.local(2023, 5, 18, 1, 15, 0) do
      first_lot.end_date = 10.seconds.from_now
      first_lot.save!

      image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
      first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                                description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                                photo: image,
                                weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

      ItemLot.create!(lot_id: first_lot.id, item_id: first_item.id)
      first_lot.reload

      first_lot.update(approved_by_id: admin_2.id)

      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 2000)
    end
    first_lot.update!(status: :succeeded)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    expect(page).to have_content('ABC123')
    expect(page).to have_content('Parabéns! Você é o vencedor deste lote!')
    within('div#lot-ABC123') do
      expect(page).to have_css('div.card-header.bg-success')
    end
  end

  it 'E venceu um lote vencendo outro usuário' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')
    login_as(user_1)

    user_2 = User.create!(name: 'Joãozinho da Silva', email: 'segundouser@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '728.773.530-01')

    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

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

      Bid.create!(lot_id: first_lot.id, user_id: user_2.id, value: 2000)
      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 3000)
    end

    first_lot.update(status: :succeeded)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    expect(page).to have_content('ABC123')
    expect(page).to have_content('Parabéns! Você é o vencedor deste lote!')
    within('div#lot-ABC123') do
      expect(page).to have_css('div.card-header.bg-success')
    end
  end

  it 'E deu um lance mas não venceu o lote' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')
    login_as(user_1)

    user_2 = User.create!(name: 'Joãozinho da Silva', email: 'segundouser@gmail.com', password: 'password',
                          sex: 1, role: :user, cpf: '728.773.530-01')

    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

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

      Bid.create!(lot_id: first_lot.id, user_id: user_2.id, value: 2000)
      Bid.create!(lot_id: first_lot.id, user_id: user_1.id, value: 3000)
      Bid.create!(lot_id: first_lot.id, user_id: user_2.id, value: 4000)
    end

    first_lot.update(status: :succeeded)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    expect(page).not_to have_content('ABC123')
  end

  it 'E clica em ver lote em um lote que ele venceu' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                          sex: 2, role: :user, cpf: '810.460.860-65')
    login_as(user_1)

    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

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

    first_lot.update(status: :succeeded)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    within('div#lot-ABC123') do
      click_on 'Ver lote'
    end

    expect(page).to have_content('ABC123')
    expect(page).to have_content('Caneca Botafogo Cerâmica')
    expect(page).to have_content('Lote finalizado com sucesso!')
    expect(page).to have_content('Parabéns! Você é o vencedor deste lote!')
    expect(page).to have_content('Maior lance do lote: R$ 2.000,00')
  end
end
