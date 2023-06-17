class Lot < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
  has_many :item_lot
  has_many :items, through: :item_lot
  has_many :bids

  enum status: { canceled: 0, succeeded: 1, ongoing: 2 }

  accepts_nested_attributes_for :items

  validates :code, :start_date, :end_date, :minimum_value, :minimum_difference, presence: true
  validates :code, uniqueness: true
  validates :minimum_value, numericality: { greater_than: 99 }
  validates :minimum_difference, numericality: { greater_than: 9 }

  validate :end_date_cannot_be_in_the_past, if: :end_date_changed?
  validate :code_needs_three_letters_and_six_characters
  validate :approved_by_cant_be_set_if_the_lot_has_no_items, on: :update
  validate :created_by_cant_be_the_same_as_approved_by

  def end_date_cannot_be_in_the_past
    return unless end_date.present? && end_date < Time.now

    errors.add(:end_date, 'não pode estar no passado')
  end

  def code_needs_three_letters_and_six_characters
    errors.add(:code, 'precisa de 6 caracteres no total') if code.present? && code.length != 6
    errors.add(:code, 'precisa de 3 letras') if code.present? && code.scan(/[A-Z]/i).count != 3
    return unless code.present? && code.scan(/\d/).count != 3

    errors.add(:code, 'precisa de 3 números')
  end

  def approved_by_cant_be_set_if_the_lot_has_no_items
    return if approved_by_id.present? && items.any?

    errors.add(:approved_by_id, 'não pode ser definido em um lote sem itens')
  end

  def created_by_cant_be_the_same_as_approved_by
    return unless created_by_id.present? && approved_by_id.present? && created_by_id == approved_by_id

    errors.add(:approved_by_id, 'não pode ser o mesmo que o criador do lote')
  end

  def self.unnaproved
    Lot.where('approved_by_id IS NULL')
  end

  def self.approved
    unnaproved_lots = Lot.unnaproved.pluck(:id)
    Lot.where.not(id: unnaproved_lots)
  end

  def self.ongoing
    Lot.where('start_date < ? AND end_date > ?', Time.current, Time.current).where.not(approved_by_id: nil)
  end

  def self.future
    Lot.where('start_date > ?', Time.current).where.not(approved_by_id: nil)
  end

  def self.closed
    Lot.where('end_date < ?', Time.current)
  end
end
