require 'rails_helper'

describe "Administrador cria lote" do
  it 'E visuzaliza todos os campos' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
      sex:1, role: :admin, cpf: '764.424.940-04')
    login_as(User.last)

    visit root_path
    click_on 'Lotes'
    click_on 'Cadastrar lote'

    expect(page).to have_content('Código')
    expect(page).to have_content('Data de início')
    expect(page).to have_content('Data final')
    expect(page).to have_content('Valor mínimo')
    expect(page).to have_content('Diferença mínima')
    expect(page).to have_button('Criar Lote')
  end

  it 'E preenche com dados inválidos' do
    # wladimir, volta
  end

  it 'E preenche com dados em branco' do
    # wladimir, volta
  end

  it 'E preenche todos os campos' do
    User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
                sex:1, role: :admin, cpf: '764.424.940-04')
    login_as(User.last)

    visit root_path
    click_on 'Lotes'
    click_on 'Cadastrar lote'

    fill_in "Código",	with: "C0FF33" 
    fill_in "Data de início",	with: "01/11/2023"
    fill_in "Data final",	with: "01/12/2023"
    fill_in "Valor mínimo",	with: "1000"
    fill_in "Diferença mínima",	with: "100"
    click_on 'Criar Lote'
    
    expect(page).to have_content('Lote criado com sucesso')
    expect(page).to have_content('Items do lote:')
    expect(page).to have_content('C0FF33')
    expect(page).to have_content('Data de abertura: 01 de novembro, 00:00')
    expect(page).to have_content('Data de fechamento: 01 de dezembro, 00:00')
    expect(page).to have_content('Valor inicial do lote: R$ 1.000,00')
    expect(page).to have_content('Diferença mínima entre lances: R$ 100,00')
    expect(page).to have_content('Aguardando')
    expect(page).to have_content('Não aprovado')
    expect(page).to have_content('Criado por: Wladimir Souza')
    expect(page).to have_link('Editar lote')
    expect(page).to have_link('Voltar')
  end
end