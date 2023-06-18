# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find params[:id]
  end

  def new
    @item = Item.new
    @categories = Category.all
  end

  def create
    @item = Item.new item_params
    @item.user_id = current_user.id
    if @item.save
      redirect_to @item, notice: 'Item cadastrado com sucesso!'
    else
      @categories = Category.all
      flash.now[:alert] = 'Não foi possível cadastrar o item'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :photo, :weight, :width, :height, :depth, category_ids: [])
  end
end
