require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E não há itens cadastrados' do
    visit root_path
    within('nav') do
      click_on 'Itens'
    end

    expect(page).to have_content('Nenhum item cadastrado')
  end

  it 'E não vê botão de cadastrar item' do
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(User.last)
    visit root_path
    click_on 'Itens'

    expect(page).not_to have_content('Cadastrar item')
  end

  it 'E vê todos os itens cadastrados' do
    # Arrange
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
                sex:1, role: :user, cpf: '111.222.333.44')
    login_as(User.last)

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
    click_on 'Itens'

    expect(page).to have_content('Itens')
    within("div#item-IPHON12345") do
      expect(page).to have_content('Iphone 15.5 XS')
    end
    within("div#item-99999CAFES") do
      expect(page).to have_content('Samsung Galaxy S20')
    end
  end

  it 'E os itens tem a descrição encurtada' do
    # Arrange
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
      sex:1, role: :user, cpf: '111.222.333.44')
    login_as(User.last)

    image = fixture_file_upload(Rails.root.join('spec/support/images/iphonexs.png'), 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).and_return('IPHON12345')
    item_iphone = Item.create!(name: 'Iphone 15.5 XS',
                  description: 'O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bionic, o iPhone XS oferece desempenho poderoso e eficiência energética. Possui uma tela OLED Super Retina de 5,8 polegadas, que proporciona cores vibrantes e pretos profundos, além de suporte ao HDR10 e Dolby Vision.',
                  photo: image, weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)
    
    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Itens')
    within("div#item-IPHON12345") do
      expect(page).to have_content('O iPhone XS é um smartphone da Apple lançado em setembro de 2018. Equipado com um processador A12 Bi...')
    end
  end
 
end