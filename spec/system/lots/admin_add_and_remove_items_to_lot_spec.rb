require 'rails_helper'

describe 'Administrador altera items do lote' do
  it 'Adiciona' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '764.424.940-04')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
                  sex:1, role: :admin, cpf: '621.830.060-99')

    Lot.create!(code: 'ABC123', start_date: '2023-05-30 15:30:00', end_date: '2024-05-30 15:30:00',
                  minimum_value: 1000, minimum_difference: 100,
                  created_by_id: 2)
    
    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    item_iphone = Item.create!(name: 'Iphone 15.5 XS',
                        description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                        photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    image = fixture_file_upload(Rails.root.join('spec/support/images/s20.jpg'), 'image/jpg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('99999CAFES')
    item_samsung = Item.create!(name: 'Samsung Galaxy S20',
                        description: 'O Samsung Galaxy S20 é um smartphone Android com características inovadoras que o tornam uma excelente opção para qualquer tipo de utilização. A tela de 6.2 polegadas coloca esse Samsung no topo de sua categoria. A resolução também é alta: 3200x1440 pixel. As funcionalidades oferecidas pelo Samsung Galaxy S20 são muitas e top de linha. Começando pelo LTE 5G que permite a transferência de dados e excelente navegação na internet.',
                        photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)
              

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Adicionar items'
    end

    check 'Adicionar - IPHON12345'
    check 'Adicionar - 99999CAFES'

    within("div#form-top") do
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Lote atualizado com sucesso!')
    expect(page).to have_content('Iphone 15.5 XS')
    expect(page).to have_content('Samsung Galaxy S20')
  end

  it 'Remove' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '764.424.940-04')
      
    login_as(admin_1)

    admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
                  sex:1, role: :admin, cpf: '621.830.060-99')

    Lot.create!(code: 'ABC123', start_date: '2023-05-30 15:30:00', end_date: '2024-05-30 15:30:00',
                  minimum_value: 1000, minimum_difference: 100,
                  created_by_id: 2)
    
    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    item_iphone = Item.create!(name: 'Iphone 15.5 XS',
                        description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                        photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    image = fixture_file_upload(Rails.root.join('spec/support/images/s20.jpg'), 'image/jpg')
    allow(SecureRandom).to receive(:alphanumeric).and_return('99999CAFES')
    item_samsung = Item.create!(name: 'Samsung Galaxy S20',
                        description: 'O Samsung Galaxy S20 é um smartphone Android com características inovadoras que o tornam uma excelente opção para qualquer tipo de utilização. A tela de 6.2 polegadas coloca esse Samsung no topo de sua categoria. A resolução também é alta: 3200x1440 pixel. As funcionalidades oferecidas pelo Samsung Galaxy S20 são muitas e top de linha. Começando pelo LTE 5G que permite a transferência de dados e excelente navegação na internet.',
                        photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)
    ItemLot.create!(item_id: item_iphone.id, lot_id: Lot.last.id)
    ItemLot.create!(item_id: item_samsung.id, lot_id: Lot.last.id)

    visit root_path
    within('nav') do
      click_on 'Lotes'
    end

    within("div#lot-#{Lot.last.code}") do
      click_on 'Adicionar items'
    end

    uncheck 'Adicionado - IPHON12345'

    within("div#form-top") do
      click_on 'Salvar Edição'
    end

    expect(page).to have_content('Lote atualizado com sucesso!')
    expect(page).to have_content('Samsung Galaxy S20')
    expect(page).not_to have_content('Iphone 15.5 XS')
  end
end