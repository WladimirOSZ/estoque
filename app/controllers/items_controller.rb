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
    @item.user = current_user
    if @item.save
      item_id = @item.id
      puts "item_id: #{item_id}"
      params[:item][:category_id].each do |category_id|
        puts "category_id: #{category_id}"
        ItemCategory.create!(item_id: item_id, category_id: category_id)
      end

      redirect_to @item, notice: 'Item cadastrado com sucesso!'
    else
      @categories = Category.all
      flash.now[:alert] = 'Não foi possível cadastrar o item'
      render :new, status: :unprocessable_entity
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :photo, :weight, :width, :height, :depth, :category_id => [])
  end
end