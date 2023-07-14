require 'rails_helper'

describe 'Administrador aprova lote' do
  it 'Falha por ser o criador do lote' do
    admin1 = create(:user, :admin)

    login_as(admin1)

    Lot.create!(code: 'ABC123', start_date: 1.day.from_now, end_date: 2.days.from_now,
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
    admin1 = create(:user, :admin)

    login_as(admin1)

    create(:user, :second_admin)

    Lot.create!(code: 'ABC123', start_date: 1.day.from_now, end_date: 2.days.from_now,
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
    admin1 = create(:user, :admin)
    create(:user, :second_admin)

    Lot.create!(code: 'ABC123', start_date: 1.day.from_now, end_date: 2.days.from_now,
                minimum_value: 1000, minimum_difference: 100,
                created_by_id: 2)

    fixture_file_upload(Rails.root.join('app/assets/images/caneca-botafogo.jpg'), 'image/jpeg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')
    first_item = create(:item, user: admin1)

    ItemLot.create!(lot_id: Lot.last.id, item_id: first_item.id)

    login_as(admin1)
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
