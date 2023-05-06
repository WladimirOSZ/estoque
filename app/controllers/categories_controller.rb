class CategoriesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Categoria cadastrada com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível cadastrar a categoria'
      render :new, status: :unprocessable_entity
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end