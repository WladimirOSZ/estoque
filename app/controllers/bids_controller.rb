class BidsController < ApplicationController
  before_action :authenticate_user!

  def create
    @bid = Bid.new bid_params
    @bid.user = current_user
    @lot = Lot.find(params[:bid][:lot_id])

    if @bid.save
      redirect_to @lot, notice: 'Lance cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível fazer o lance'
      render 'lots/show', status: :unprocessable_entity
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:value, :lot_id)
  end
end
