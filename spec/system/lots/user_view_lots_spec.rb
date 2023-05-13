require 'rails_helper'

describe 'Usuário visualiza lotes' do
  it 'E vê todos os lotes cadastrados' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
                  sex:2, role: :user, cpf: '491.150.798.57')
    
    login_as(user_1)

    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                  sex:1, role: :admin, cpf: '491.150.798.55')

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
                  sex:1, role: :admin, cpf: '491.150.798.50')

    Lot.create!(code: 'ABC123', start_date: '2023-05-01 15:30:00', end_date: 1.days.from_now,
                  mininum_value: 1000, mininum_difference: 100,
                  created_by_id: 2, approved_by_id: 3)

    Lot.create!(code: '3C1A2B', start_date: 5.minutes.from_now, end_date: 5.days.from_now,
                  mininum_value: 1000, mininum_difference: 100,
                  created_by_id: 2, approved_by_id: 3)
        

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-ABC123") do
      expect(page).to have_content('Lote ABC123')
      expect(page).to have_content('Aberto')
      expect(page).to have_link('Ver lote')
    end

    within("div#lot-3C1A2B") do
      expect(page).to have_content('Lote 3C1A2B')
      expect(page).to have_content('Fechado')
      expect(page).to have_link('Ver lote')
    end
  end
end