class ItemsLotsController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create]

  def new
    @lot = Lot.find(params[:lot_id])
    
    if is_open(@lot)
      @items = Item.all
      @items_lot = ItemLot.new
    else
      redirect_to lots_path, notice: "O leilão está fechado"
    end
  end

  def create
    @items_lot = ItemLot.new(items_lot_params)
    @items_lot.lot_id = params[:lot_id]

    if @items_lot.save
      redirect_to @items_lot
    else
      render :new
    end
  end

  private
  def is_open(lot)
    Date.today.between?(lot.start_date, lot.end_date)
  end
  def items_lot_params
    params.require(:item_lot).permit(:item_ids => [])
  end
end