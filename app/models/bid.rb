class Bid < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  validates :value, presence: true
  validate :value_greater_than_minimun_value
  validate :value_greater_than_last_bid_plus_minimum_difference
  validate :lot_must_be_open
  validate :bidder_cannot_be_admin

  private

  def value_greater_than_minimun_value
    return unless value.present? && value < lot.minimum_value

    errors.add(:value, 'deve ser maior que o valor mínimo do lote')
  end

  def value_greater_than_last_bid_plus_minimum_difference
    last_bid = lot.bids.last
    return unless last_bid && value <= (last_bid.value + lot.minimum_difference)

    errors.add(:value, 'deve ser maior que o último lance mais a diferença mínima')
  end

  def lot_must_be_open
    return unless lot.end_date < Time.now

    errors.add(:lot, 'já fechou. Não é mais possível dar lances')
  end

  def bidder_cannot_be_admin
    return unless user.present? && user.admin?

    errors.add(:user, 'não pode ser administrador')
  end
end
