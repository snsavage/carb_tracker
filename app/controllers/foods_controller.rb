class FoodsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, except: [:index, :new, :create]
  after_action :verify_policy_scoped, only: :index

  def index
    @foods = policy_scope(Food)
  end

  def show
    @food = Food.find(params[:id])
    authorize @food
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
    @food = Food.find(params[:id])
    authorize @food
  end

  def update
    @food = Food.find(params[:id])
    authorize @food

    @food.update(food_params)

    if @food.save
      redirect_to food_path(@food)
    else
      render :edit
    end
  end

  def destroy
    @food = Food.find(params[:id])
    authorize @food

    if @food.destroy
      redirect_to foods_path, notice: "#{@food.unique_name} was deleted."
    else
      redirect_to food_path(@food),
                  alert: "#{food.unique_name} could not be deleted."
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
