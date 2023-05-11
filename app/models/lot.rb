class Lot < ApplicationRecord

  validates :code, :start_date, :end_date, :mininum_value, :mininum_difference, presence: true
  validates :code, uniqueness: true
  validates :mininum_value, :mininum_difference, numericality: { greater_than: 99 }
  validates :mininum_difference, numericality: { greater_than: 99 }


  validate :end_date_cannot_be_in_the_past
  validate :code_needs_three_letters_and_six_characters
  validate :created_by_needs_to_be_admin
  validate :approved_by_needs_to_be_admin
  validate :created_by_cant_be_the_same_as_approved_by

  def end_date_cannot_be_in_the_past
    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "can't be in the past")
    end
  end

  def code_needs_three_letters_and_six_characters
    if code.present? && code.length != 6
      errors.add(:code, " precisa de 6 caracteres no total")
      if code.scan(/[A-Z]/i).count != 3
        errors.add(:code, " precisa de 3 letras")
      end
    end
  end

  def created_by_needs_to_be_admin
    if created_by_id.present? && User.find(created_by_id).role != 'admin'
      errors.add(:created_by_id, "precisa ser um administrador")
    end
  end

  def approved_by_needs_to_be_admin
    if approved_by_id.present? && User.find(approved_by_id).role != 'admin'
      errors.add(:approved_by_id, "precisa ser um administrador")
    end
  end

  def created_by_cant_be_the_same_as_approved_by
    if created_by_id.present? && approved_by_id.present? && created_by_id == approved_by_id
      errors.add(:created_by_id, "não pode ser o mesmo que o aprovador")
    end
  end

end
