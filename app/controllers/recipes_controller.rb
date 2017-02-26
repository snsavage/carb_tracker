class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @foods = Food.all
    @search_foods = []
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      if api.errors?
        flash[:error] = api.messages
        @foods = Food.all
        @search_foods = []
      else
        @search_foods = Food.find_or_create_from_api(api.foods)
        @recipe.foods << @search_foods
        flash[:success] = t ".search.success"
        @foods = Food.all - @search_foods
      end

      render :new

    elsif params[:commit] == "Create Recipe"
      @recipe = Recipe.create(recipe_params)
      if @recipe.invalid?
        @foods = Food.all
        @search_foods = []
        render :new
      else
        redirect_to recipe_path(@recipe)
      end
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :public, food_ids: [])
  end
end
