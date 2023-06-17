require 'rails_helper'

RSpec.describe Lot, type: :model do
  context 'presence' do
    it 'false when code name is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

      lot = Lot.new(
        code: '',
        start_date: '2021-05-01 10:15:00', end_date: '2023-05-30 15:30:00',
        minimum_value: 100, minimum_difference: 10,
        created_by: admin_1, approved_by: admin_2
      )

      result = lot.valid?

      expect(result).to eq(false)
    end

    it 'is invalid when start_date is empty' do
      admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

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
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

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
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

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
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

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
                             sex: 1, role: :admin, cpf: '764.424.940-04')

      admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                             sex: 1, role: :admin, cpf: '621.830.060-99')

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

  it 'is invalid when code is not unique' do
    admin_1 = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '764.424.940-04')

    admin_2 = User.create!(name: 'Caio Willwohl', email: 'admin2@leilaodogalpao.com.br', password: 'password',
                           sex: 1, role: :admin, cpf: '621.830.060-99')

    Lot.create!(
      code: 'ABC123',
      start_date: '2021-05-01 10:15:00', end_date: 1.days.from_now,
      minimum_value: 100, minimum_difference: 10,
      created_by: admin_1, approved_by: admin_2
    )

    lot2 = Lot.new(
      code: 'ABC123',
      start_date: '2021-05-01 10:15:00', end_date: 1.days.from_now,
      minimum_value: 100, minimum_difference: 10,
      created_by: admin_1, approved_by: admin_2
    )

    result = lot2.valid?

    expect(result).to eq(false)
  end

  # validates :minimum_value, numericality: { greater_than: 99 }
  # validates :minimum_difference, numericality: { greater_than: 9 }

  # validate :end_date_cannot_be_in_the_past, if: :end_date_changed?
  # validate :code_needs_three_letters_and_six_characters
  # validate :created_by_needs_to_be_admin
  # validate :approved_by_needs_to_be_admin
  # validate :approved_by_cant_be_set_if_the_lot_has_no_items, on: :update
  # validate :created_by_cant_be_the_same_as_approved_by

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

  it 'is invalid when created_by is not an admin' do
    user = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                        sex: 1, role: :user, cpf: '764.424.940-04')

    lot = Lot.new(created_by_id: user)
    lot.valid?

    expect(lot.errors[:created_by]).to include('precisa ser um administrador')
  end

  it 'is invalid when approved_by is not an admin' do
    user = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                        sex: 1, role: :user, cpf: '764.424.940-04')

    lot = Lot.new(approved_by: user)
    lot.valid?
    expect(lot.errors[:approved_by_id]).to include('precisa ser um administrador')
  end

  it 'is invalid when approved_by is set for a lot without items' do
    admin = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                         sex: 1, role: :admin, cpf: '764.424.940-04')

    lot = Lot.new(approved_by: admin)
    lot.valid?
    expect(lot.errors[:approved_by_id]).to include('não pode ser definido em um lote sem items')
  end

  it 'is invalid when created_by and approved_by are the same user' do
    admin = User.create!(name: 'Wladimir Souza', email: 'admin@leilaodogalpao.com.br', password: 'password',
                         sex: 1, role: :admin, cpf: '764.424.940-04')

    lot = Lot.new(created_by: admin, approved_by: admin)
    lot.valid?
    expect(lot.errors[:approved_by_id]).to include('não pode ser o mesmo que o criador do lote')
  end
end
