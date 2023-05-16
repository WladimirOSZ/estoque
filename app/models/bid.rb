class Bid < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  validates :value, presence: true
  validate :value_greater_than_minimun_value
  validate :value_greater_than_last_bid_plus_minimum_difference

  private
  def value_greater_than_minimun_value
    if value.present? && value < lot.minimum_value
      errors.add(:value, "Deve ser maior que o valor mínimo do lote")
    end
  end

  def value_greater_than_last_bid_plus_minimum_difference
    last_bid = lot.bids.last
    if last_bid && value <= (last_bid.value + lot.minimum_difference)
      errors.add(:value, "deve ser maior que o último lance mais a diferença mínima")
    end
  end



end
