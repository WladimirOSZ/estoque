module LotsHelper
  def is_open(lot)
    Time.now.between?(lot.start_date, lot.end_date)
  end

  def is_waiting(lot)
    Time.now < lot.start_date
  end
  
  def current_time_status(lot)
    is_open(lot) ? "Aberto"  : is_waiting(lot) ? "Aguardando" : "Fechado"
  end
  
  def is_closed(lot)
    !is_open(lot)
  end

  def is_approved(lot)
    lot.approved_by_id.present?
  end

  def is_approved_status(lot)
    is_approved(lot) ? "Aprovado" : "Não aprovado"
  end
  
end
