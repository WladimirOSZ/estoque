module BidsHelper
  def higghest_bid(lot)
    lot.bids.where(lot_id: lot.id).last&.value
  end

  def higghest_bid_as_text_or_currency(lot)
    higghest_bid(lot) ? number_to_currency(higghest_bid(lot)) : "Não há lances"
  end

  def minimum_bid(lot)
    higghest_bid = higghest_bid(lot)
    if higghest_bid.present?
      return higghest_bid + lot.minimum_difference
    end
    lot.minimum_value
  end
end