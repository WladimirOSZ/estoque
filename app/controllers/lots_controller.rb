class LotsController < ApplicationController
  def index
    @lots = Lot.all
  end
  

  def lista_users_teste
    @users = User.all 
  end

  def new
    @lot = Lot.new
  end
end