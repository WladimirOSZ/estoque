module LotsHelper
  def is_open(lot)
    Time.now.between?(lot.start_date, lot.end_date)
  end

  def is_waiting(lot)
    Time.now < lot.start_date
  end

  def current_time_status(lot)
    if is_open(lot)
      'Aberto'
    else
      is_waiting(lot) ? 'Aguardando' : 'Fechado'
    end
  end

  def is_closed(lot)
    !is_open(lot)
  end

  def is_approved(lot)
    lot.approved_by_id.present?
  end

  def is_approved_status(lot)
    is_approved(lot) ? 'Aprovado' : 'Não aprovado'
  end

  def user_is_lot_winner(lot)
    return unless is_closed(lot) && lot.bids.present? && current_user.present? && lot.succeeded?

    lot.bids.last.user == current_user
  end
end
