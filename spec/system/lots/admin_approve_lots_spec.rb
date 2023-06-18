# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador aprova lote' do
  it 'Falha por ser o criador do lote' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    Lot.create!(code: 'ABC123', start_date: 1.days.from_now, end_date: 2.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 1)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Ver lote'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Editar lote'
    end

    within('div#form-top') do
      check 'Aprovar'
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Não foi possível atualizar o lote')
    expect(page).to have_content('Aprovado por não pode ser o mesmo que o criador do lote')
  end

  it 'Falha por que o lote não tem items' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                 sex: 1, role: :admin, cpf: '621.830.060-99')

    Lot.create!(code: 'ABC123', start_date: 1.days.from_now, end_date: 2.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 2)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Ver lote'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Editar lote'
    end

    within('div#form-top') do
      check 'Aprovar'
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Não foi possível atualizar o lote')
    expect(page).to have_content('Aprovado por não pode ser definido em um lote sem itens')
  end

  it 'Com sucesso' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    login_as(admin_1)

    User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                 sex: 1, role: :admin, cpf: '621.830.060-99')

    Lot.create!(code: 'ABC123', start_date: 1.days.from_now, end_date: 2.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 2)

    image = fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = Item.create!(name: 'Caneca Botafogo Cerâmica',
                              description: 'Mostre o seu amor pelo Botafogo de Futebol e Regatas com a nossa caneca personalizada. Feita de cerâmica durável, a caneca apresenta o emblemático logotipo em preto e branco do Botafogo. Com capacidade para 350ml, é perfeita para a sua bebida preferida. Comece o dia em grande estilo e demonstre a sua paixão pelo Botafogo com esta caneca incrível.',
                              photo: image,
                              weight: 300, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemLot.create!(lot_id: Lot.last.id, item_id: first_item.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Ver lote'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Editar lote'
    end

    within('div#form-top') do
      check 'Aprovar'
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Lote atualizado com sucesso!')
    expect(page).to have_content('Aprovado')
  end
end
