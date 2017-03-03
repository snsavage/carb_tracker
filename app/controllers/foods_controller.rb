class FoodsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @foods = current_user.foods.order(:unique_name)
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    @food = current_user.foods.create(food_params)

    if @food.valid?
      redirect_to food_path(@food)
    else
      render :new
    end
  end

  def edit
    @food = current_user.foods.find(params[:id])
  end

  def update
    @food = current_user.foods.find(params[:id])
    @food.update(food_params)

    if @food.save
      redirect_to food_path(@food)
    else
      render :edit
    end
  end

  private
  def food_params
    params.require(:food).permit(
      :food_name,
      :serving_qty,
      :serving_unit,
      :calories,
      :total_fat,
      :total_carbohydrate,
      :protein
    )
  end
end

