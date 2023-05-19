require 'rails_helper'

describe "Usuário visualiza leilão que ganhou" do
  it 'E não ganhou nenhum' do
    user_1 = User.create!(name: 'Joana Dark', email: 'user@user.com', password: 'password',
      sex:2, role: :user, cpf: '491.150.798.57')

    login_as(user_1)

    visit root_path
    within('nav') do
      click_on 'Lotes vencidos'
    end

    expect(page).to have_content('Você não ganhou nenhum leilão. Caso tenha vencido, aguarde um administrador validar o lote para ele aparecer nesta tela. Este processo pode levar até 24 horas.')
  end
end