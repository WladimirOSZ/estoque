require 'rails_helper'

RSpec.describe Lot, type: :model do
  context 'presence' do
    it 'false when code name is empty' do
      admin1 = create(:user, :admin)
      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: '',
        start_date: '2021-05-01 10:15:00', end_date: '2023-05-30 15:30:00',
        minimum_value: 100, minimum_difference: 10,
        created_by: admin1, approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when start_date is empty' do
      admin1 = create(:user, :admin)

      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: 'ABC123',
        start_date: '',
        end_date: '2023-05-30 15:30:00',
        minimum_value: 100,
        minimum_difference: 10,
        created_by: admin1,
        approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when end_date is empty' do
      admin1 = create(:user, :admin)

      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: 'ABC123',
        start_date: '2021-05-01 10:15:00',
        end_date: '',
        minimum_value: 100,
        minimum_difference: 10,
        created_by: admin1,
        approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when minimum_value is empty' do
      admin1 = create(:user, :admin)

      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: 'ABC123',
        start_date: '2021-05-01 10:15:00',
        end_date: '2023-05-30 15:30:00',
        minimum_value: nil,
        minimum_difference: 10,
        created_by: admin1,
        approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when minimum_difference is empty' do
      admin1 = create(:user, :admin)

      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: 'ABC123',
        start_date: '2021-05-01 10:15:00',
        end_date: '2023-05-30 15:30:00',
        minimum_value: 120,
        minimum_difference: nil,
        created_by: admin1,
        approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when created_by is empty' do
      User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                   sex: 1, role: :admin, cpf: '764.424.940-04')

      admin2 = create(:user, :second_admin)

      lot = Lot.new(
        code: 'ABC123',
        start_date: '2021-05-01 10:15:00',
        end_date: '2023-05-30 15:30:00',
        minimum_value: 120,
        minimum_difference: 10,
        created_by: nil,
        approved_by: admin2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end
  end

  it 'is invalid when code is not unique' do
    admin1 = create(:user, :admin)

    admin2 = create(:user, :second_admin)

    Lot.create!(
      code: 'ABC123',
      start_date: '2021-05-01 10:15:00', end_date: 1.day.from_now,
      minimum_value: 100, minimum_difference: 10,
      created_by: admin1, approved_by: admin2
    )

    lot2 = Lot.new(
      code: 'ABC123',
      start_date: '2021-05-01 10:15:00', end_date: 1.day.from_now,
      minimum_value: 100, minimum_difference: 10,
      created_by: admin1, approved_by: admin2
    )

    result = lot2.valid?

    expect(result).to eq(false)
  end

  it 'is invalid when minimum_value is less than 100' do
    lot = Lot.new(minimum_value: 90)

    lot.valid?

    expect(lot.errors[:minimum_value]).to include('deve ser maior que 99')
  end

  it 'is invalid when end date is in the past' do
    lot = Lot.new(
      end_date: '2021-05-30'
    )

    lot.valid?

    expect(lot.errors[:end_date]).to include('não pode estar no passado')
  end

  it 'is invalid when code is not 6 characters' do
    lot = Lot.new(code: 'ABC1')
    lot.valid?
    expect(lot.errors[:code]).to include('precisa de 6 caracteres no total')
  end

  it 'is invalid when code does not have 3 letters' do
    lot = Lot.new(code: '123456')
    lot.valid?
    expect(lot.errors[:code]).to include('precisa de 3 letras')
  end

  it 'is invalid when approved_by is set for a lot without items' do
    admin = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                         sex: 1, role: :admin, cpf: '764.424.940-04')

    lot = Lot.create!(code: 'ABC123', start_date: 1.day.from_now, end_date: 2.days.from_now,
                      minimum_value: 1000, minimum_difference: 100, created_by_id: 1)
    lot.update(approved_by: admin)

    expect(lot.errors[:approved_by_id]).to include('não pode ser definido em um lote sem itens')
  end

  it 'is invalid when created_by and approved_by are the same user' do
    admin = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                         sex: 1, role: :admin, cpf: '764.424.940-04')

    lot = Lot.new(created_by: admin, approved_by: admin)
    lot.valid?
    expect(lot.errors[:approved_by_id]).to include('não pode ser o mesmo que o criador do lote')
  end
end
