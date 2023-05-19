class LotsController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :waiting_approval, :update_approval]
  before_action :authenticate_user!, only: [:won_lots]

  def index
    if current_user.present? && current_user.admin?
      @unnaproved_lots = Lot.unnaproved
    end
    @lots = Lot.approved
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
    @bid = Bid.new
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

  def waiting_approval
    @lots = Lot.where("end_date < ?", Time.now).where(status: :ongoing)
    @lots_succeded = Lot.succeeded
    @lots_canceled = Lot.canceled
  end

  def update_approval
    @lot = Lot.find(params[:id])

    # wladimir, volta aqui. isso ta feio.
    if params[:canceled] == "true"
      @lot.status = :canceled
    elsif params[:canceled] == "false"
      @lot.status = :succeeded
    end


    if @lot.valid? 
      Lot.transaction do
        if @lot.save
          @lot.item_lot.update_all(canceled: params[:canceled])
          redirect_to waiting_approval_lots_path, notice: 'Status do lote atualizado com sucesso!'
        else
          redirect_to waiting_approval_lots_path, alert: 'Não foi possível atualizar o lote'
        end
      end
    else
      puts @lot.errors.full_messages

      redirect_to waiting_approval_lots_path, alert: 'Não foi possível atualizar o lote'
    end
  end

  def won_lots
    lots_bidded_from_this_user = current_user.bids.select(:lot_id).distinct
    ended_lots = Lot.where(id: lots_bidded_from_this_user).where(status: :succeeded)

    higghest_bids_from_user = current_user.bids.group(:lot_id).maximum(:value)

    @won_lots = ended_lots.select { |lot| higghest_bids_from_user[lot.id] == lot.bids.last.value }
    
  end

  private
  def create_lot_params
    params.require(:lot).permit(:code, :start_date, :end_date, :minimum_value, :minimum_difference)
  end

  def update_lot_params
    params.require(:lot).permit(:approved_by_id, :start_date, :end_date, :minimum_value, :minimum_difference,:item_ids => [])
  end
end