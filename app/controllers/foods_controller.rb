class FoodsController < ApplicationController
  def new
    @foods = Food.all
  end

  def search
    if params[:search].present?
      line_delimited = params[:line_delimited] == "true" ? true : false

      @search = NutritionIx.new(params[:search], line_delimited).foods

      @foods = @search.collect do |search|
        Food.create(search)
      end
    end

    redirect_to new_food_path
  end

end
