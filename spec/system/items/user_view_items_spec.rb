require 'rails_helper'

describe 'Usuário visualiza itens' do
  it 'E vê todos os itens cadastrados' do
    # Arrange
    User.create!(name: 'Wladimir Oliveira',email: 'user@gmail.com', password: 'password',
                sex:1, role: :user)
    login_as(User.last)

    Category.create!(name: 'Celulares')
    Category.create!(name: 'Televisões')
    Category.create!(name: 'Eletrônicos')

    item = Item.create!(name: 'Iphone 15.5 XS', description: 'Celular novo', photo: 'celular.jpg',
                        weight: 1, width: 10, height: 10, depth: 10, user_id: User.last.id)

    ItemCategory.create!(item_id: item.id, category_id: Category.first.id)
    ItemCategory.create!(item_id: item.id, category_id: Category.last.id)

    # Act
    visit root_path
    click_on 'Itens'

    # Assert
    expect(page).to have_content('Itens')
    expect(page).to have_content('Iphone 15.5 XS')

    expect(item.categories.count).to eq(2)
    expect(item.categories.first.name).to eq('Celulares')
    expect(item.categories.last.name).to eq('Eletrônicos')


  end

  it 'E não há itens cadastrados' do
    visit root_path
    click_on 'Itens'

    expect(page).to have_content('Nenhum item cadastrado')
  end

end