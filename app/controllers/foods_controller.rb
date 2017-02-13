class FoodsController < ApplicationController
  def new
    @foods = Food.all
  end

  def search
    if params[:search].present?
      line_delimited = line_delimited == "true" ? true : false
      Food.search_form(params[:search], line_delimited)
    end

    redirect_to new_food_path
  end
end

