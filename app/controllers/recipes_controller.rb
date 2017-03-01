class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.includes(ingredients: :food).find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @foods = Food.all
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      @recipe.foods << Food.find_or_create_from_api(api.foods)
      @foods = Food.all

      flash.now[:alert] = api.messages if api.errors?
      flash[:notice] = t ".search.success" unless api.errors?
      render :new

    elsif params[:commit] == "Create Recipe"
      @recipe = Recipe.create(recipe_params)
      @foods = Food.all

      if @recipe.invalid?
        @foods = Food.all
        render :new and return
      end

      redirect_to recipe_path(@recipe)
    end
  end

  def edit
    @recipe = Recipe.includes(:ingredients).find(params[:id])
    @foods = Food.all
  end

  def update
    @recipe = Recipe.includes(ingredients: [:food]).find(params[:id])
    @recipe.update(recipe_params)

    if params[:commit] == "Search"
      api = NutritionIx.new(params[:recipe][:search])

      @recipe.foods << Food.find_or_create_from_api(api.foods)
      @foods = Food.all

      flash.now[:alert] = api.messages if api.errors?
      flash[:notice] = t ".search.success" unless api.errors?
      render :edit

    elsif params[:commit] == "Update Recipe"
      if @recipe.invalid?
        @foods = Food.all
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
