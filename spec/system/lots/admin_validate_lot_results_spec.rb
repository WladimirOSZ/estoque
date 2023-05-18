require 'rails_helper'

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
    dmin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '491.150.798.55')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
          sex:1, role: :admin, cpf: '491.150.798.50')

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
          minimum_value: 1000, minimum_difference: 100,
          created_by_id: admin_1.id, approved_by_id: admin_2.id)

    Lot.create!(code: '3C1A2B', start_date: 5.minutes.from_now, end_date: 5.days.from_now,
          minimum_value: 1000, minimum_difference: 100,
          created_by_id: admin_1.id, approved_by_id: admin_2.id)


    visit root_path
    within('nav') do
      click_on 'Lotes'
    end
  end
end
