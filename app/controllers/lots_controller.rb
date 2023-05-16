class LotsController < ApplicationController
  def index
    if current_user.admin?
      @unnaproved_lots = Lot.unnaproved
    end
    @lots = Lot.avaliable
  end
  

  def lista_users_teste
    @users = User.all 
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.new(create_lot_params)
    @lot.created_by = current_user
    if @lot.save
      redirect_to @lot, notice: "Lote criado com sucesso"
    else
      render 'new'
    end
  end

  def show
    @lot = Lot.find(params[:id])
    @items = Item.all
  end

  def edit
    @lot = Lot.find(params[:id])
    if @lot.approved_by_id.present?
      return redirect_to @lot, alert: 'Não é possível editar um lote aprovado'
    end
    @items = Item.avaliable
  end

  def update
    @lot = Lot.find(params[:id])
    if @lot.approved_by_id.present?
      return redirect_to @lot, alert: 'Não é possível editar um lote aprovado'
    end

    @lot.approved_by = current_user 
    modified_params = update_lot_params

    modified_params[:approved_by_id] =  modified_params[:approved_by_id] == "1" ? current_user.id : nil 

    if @lot.update(modified_params)
      redirect_to @lot, notice: 'Lote atualizado com sucesso!'
    else
      @items = Item.avaliable
      flash.now[:alert] = 'Não foi possível atualizar o lote'
      render 'edit'
    end
  end

  private
  def create_lot_params
    params.require(:lot).permit(:code, :start_date, :end_date, :minimum_value, :minimum_difference)
  end

  def update_lot_params
    params.require(:lot).permit(:approved_by_id, :start_date, :end_date, :minimum_value, :minimum_difference,:item_ids => [])
  end
end