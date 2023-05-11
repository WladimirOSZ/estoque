module LotsHelper
  def is_open(lot)
    Date.today.between?(lot.start_date, lot.end_date)
  end

  def current_time_status(lot)
    is_open(lot) ? "Aberto"  : "Fechado"
  end

  
  
end
