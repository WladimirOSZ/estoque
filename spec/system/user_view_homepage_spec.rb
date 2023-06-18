# frozen_string_literal: true

require 'rails_helper'

describe 'User visita a tela inicial' do
  it 'e vê os lotes' do
    visit root_path

    # expect(page).to have_content('Leilão de lotes')
  end
end
