class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @stats = @recipe.stats
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      if api.errors?
        flash[:error] = api.messages
        @foods = Food.all
      else
        @foods = Food.find_or_create_from_api(api.foods)
        @recipe.foods << @foods
        flash[:success] = t ".search.success"
      end

      render :new

    elsif params[:commit] == "Create Recipe"
      @recipe = Recipe.create(recipe_params)
      if @recipe.invalid?
        @foods = Food.all
        render :new
      else
        redirect_to recipe_path(@recipe)
      end
    end
  end

  private
  def recipe_params
    params.require(:recipe).permit(
      :name, :public, ingredients_attributes: [
        :id, :quantity, :food_id, :_destroy
      ]
    )
  end
end
