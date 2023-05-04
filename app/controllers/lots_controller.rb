class LotsController < ApplicationController
  def index
    @users = User.all 
  end
end