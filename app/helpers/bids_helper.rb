module BidsHelper
  def higghest_bid(lot)
    lot.bids.where(lot_id: lot.id).last&.value
  end

  def higghest_bid_as_text_or_currency(lot)
    higghest_bid(lot) ? number_to_currency(higghest_bid(lot)) : 'Não há lances'
  end

  def minimum_bid(lot)
    higghest_bid = higghest_bid(lot)
    return higghest_bid + lot.minimum_difference + 1 if higghest_bid.present?

    lot.minimum_value
  end

  def higghest_bid_is_from_this_user(lot)
    lot.bids&.last&.user.present? && lot.bids.last.user == current_user
  end

  def user_has_a_bid_in_this_lot(lot)
    current_user.present? && lot.bids.where(user_id: current_user.id).present?
  end

  def current_user_bid(lot)
    lot.bids.where(user_id: current_user.id).last.value
  end
end
