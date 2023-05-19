require 'rails_helper'

RSpec.describe Lot, type: :model do
  context 'presence' do
    it 'false when code name is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')

      lot = Lot.new(
        code: '',
        start_date: '2021-05-01 10:15:00', end_date: '2023-05-30 15:30:00',
        minimum_value: 100, minimum_difference: 10,
        created_by: admin_1, approved_by: admin_2)
      
      result = lot.valid?
    
      expect(result).to eq(false) 
    end

    it 'is invalid when start_date is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')

      lot = Lot.new(
        code: 'ABC123', 
        start_date: '', 
        end_date: '2023-05-30 15:30:00', 
        minimum_value: 100, 
        minimum_difference: 10, 
        created_by: admin_1, 
        approved_by: admin_2
      )
    
      result = lot.valid?
    
      expect(result).to eq(false) 
    end
    
    it 'is invalid when end_date is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')

      lot = Lot.new(
        code: 'ABC123', 
        start_date: '2021-05-01 10:15:00', 
        end_date: '', 
        minimum_value: 100, 
        minimum_difference: 10, 
        created_by: admin_1, 
        approved_by: admin_2
      )
    
      result = lot.valid?
    
      expect(result).to eq(false) 
    end
    
    it 'is invalid when minimum_value is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')

      lot = Lot.new(
        code: 'ABC123', 
        start_date: '2021-05-01 10:15:00', 
        end_date: '2023-05-30 15:30:00', 
        minimum_value: nil, 
        minimum_difference: 10, 
        created_by: admin_1, 
        approved_by: admin_2
      )
    
      result = lot.valid?
    
      expect(result).to eq(false) 
    end

    it 'is invalid when minimum_difference is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')
              
      lot = Lot.new(
        code: 'ABC123', 
        start_date: '2021-05-01 10:15:00', 
        end_date: '2023-05-30 15:30:00', 
        minimum_value: 120, 
        minimum_difference: nil, 
        created_by: admin_1, 
        approved_by: admin_2
      )
    
      result = lot.valid?
    
      expect(result).to eq(false) 
    end

    it 'is invalid when created_by is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
        sex:1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl',email: 'admin2@leilaodogalpao.com.br', password: 'password',
              sex:1, role: :admin, cpf: '621.830.060-99')
              
      lot = Lot.new(
        code: 'ABC123', 
        start_date: '2021-05-01 10:15:00', 
        end_date: '2023-05-30 15:30:00', 
        minimum_value: 120, 
        minimum_difference: 10, 
        created_by: nil, 
        approved_by: admin_2
      )
    
      result = lot.valid?
    
      expect(result).to eq(false) 
    end
  end
end
