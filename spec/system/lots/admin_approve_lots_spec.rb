require 'rails_helper'

describe 'Administrador aprova lote' do
  it 'Falha por ser o criador do lote' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
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

    within("div#form-top") do
      check 'Aprovar'
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Não foi possível atualizar o lote')
    expect(page).to have_content('Aprovado por não pode ser o mesmo que o criador do lote')
  end

  it 'Com sucesso' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
                  sex:1, role: :admin, cpf: '491.150.798.50')

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
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

    within("div#form-top") do
      check 'Aprovar'
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Lote atualizado com sucesso!')
    expect(page).to have_content('Aprovado')
  end

end