class LotsController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create edit update waiting_approval update_approval]
  before_action :authenticate_user!, only: [:won_lots]

  def index
    @unnaproved_lots = Lot.unnaproved if current_user.present? && current_user.admin?
    @ongoing_lots = Lot.ongoing
    @future_lots = Lot.future
    @closed_lots = Lot.closed
  end

  def lista_users_teste
    @users = User.all
  end

  def show
    @lot = Lot.find(params[:id])
    @items = Item.all
    @bid = Bid.new
  end

  def new
    @lot = Lot.new
  end

  def edit
    @lot = Lot.find(params[:id])
    return redirect_to @lot, alert: 'Não é possível editar um lote aprovado' if @lot.approved_by_id.present?

    @items = Item.avaliable
  end

  def create
    @lot = Lot.new(create_lot_params)
    @lot.created_by = current_user
    if @lot.save
      redirect_to @lot, notice: 'Lote criado com sucesso'
    else
      render 'new'
    end
  end

  def update
    @lot = Lot.find(params[:id])
    return redirect_to @lot, alert: 'Não é possível editar um lote aprovado' if @lot.approved_by_id.present?

    modified_params = update_lot_params
    approved = modified_params.delete(:approved)

    Lot.transaction do
      if @lot.update(modified_params)

        @lot.approved_by = current_user if approved == '1'
        if @lot.save
          redirect_to @lot, notice: 'Lote atualizado com sucesso!'
        else
          @items = Item.avaliable
          flash.now[:alert] = 'Não foi possível atualizar o lote'
          render 'edit'
          raise ActiveRecord::Rollback
        end
      else
        @items = Item.avaliable
        flash.now[:alert] = 'Não foi possível atualizar o lote'
        render 'edit'
        raise ActiveRecord::Rollback
      end
    end
  end

  def waiting_approval
    @lots = Lot.where('end_date < ?', Time.zone.now).where(status: :ongoing)
    @lots_succeded = Lot.succeeded
    @lots_canceled = Lot.canceled
  end

  def update_approval
    @lot = Lot.find(params[:id])
    @lot.status = params[:canceled] == 'true' ? :canceled : :succeeded

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
    params.require(:lot).permit(:approved, :start_date, :end_date, :minimum_value, :minimum_difference,
                                item_ids: [])
  end
end
