require 'rails_helper'

describe 'Usuário vê categorias' do
  it 'E existem categorias cadastradas' do
    Category.create!(name: 'Celulares')
    Category.create!(name: 'Televisões')
    Category.create!(name: 'Video Games')

    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Celulares')
    expect(page).to have_content('Televisões')
    expect(page).to have_content('Video Games')
  end

  it 'E não existem categorias cadastradas' do
    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Nenhuma categoria cadastrada.')
  end

end