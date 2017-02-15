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
        flash[:error] = klass.errors
      else
        @search_foods = Food.find_or_create_from_api(api.foods)
        @recipe.foods << @search_foods
        flash[:success] = t ".search.success"
      end

      @foods = Food.all - @search_foods
      render :new

    elsif params[:commit] == "Create Recipe"
      @recipe = Recipe.create(recipe_params)
      redirect_to recipe_path(@recipe)
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit(:name, :public, food_ids: [])
  end
end
