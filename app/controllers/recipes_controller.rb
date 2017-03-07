class RecipesController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, except: [:index, :new, :create]
  after_action :verify_policy_scoped, only: :index

  def index
    @recipes = policy_scope(Recipe)
  end

  def show
    @recipe = Recipe.includes(ingredients: :food).find(params[:id])
    authorize @recipe
  end

  def new
    @recipe = Recipe.new
    @foods = policy_scope(Food)
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      @recipe.foods << Food.find_or_create_from_api(api.foods)
      @foods = policy_scope(Food)

      flash.now[:alert] = api.messages if api.errors?
      flash[:notice] = t ".search.success" unless api.errors?
      render :new

    elsif params[:commit] == "Create Recipe"
      @recipe = Recipe.create(recipe_params)
      @foods = policy_scope(Food)

      if @recipe.invalid?
        @foods = policy_scope(Food)
        render :new and return
      end

      redirect_to recipe_path(@recipe)
    end
  end

  def edit
    @recipe = Recipe.includes(:ingredients).find(params[:id])
    @foods = policy_scope(Food)
    authorize @recipe
  end

  def update
    @recipe = Recipe.includes(ingredients: [:food]).find(params[:id])
    @recipe.update(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      @recipe.foods << Food.find_or_create_from_api(api.foods)
      @foods = policy_scope(Food)

      flash.now[:alert] = api.messages if api.errors?
      flash[:notice] = t ".search.success" unless api.errors?
      render :edit

    elsif params[:commit] == "Update Recipe"
      if @recipe.invalid?
        @foods = policy_scope(Food)
        render :edit and return
      end

      redirect_to recipe_path(@recipe)
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit(
      :name, :public, :serving_size, ingredients_attributes: [
        :id, :quantity, :food_id, :_destroy
      ]
    )
  end
end
