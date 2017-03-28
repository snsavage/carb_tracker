# FoodSearch handles searching for foods on the Recipe form with the
# NutritionIx API.
class FoodSearch
  attr_reader :messages, :api

  def initialize(recipe, params)
    @recipe = recipe
    @messages = ''
    @query = params[:recipe][:search]
    @commit = params[:commit]
    @api = search
  end

  def search?
    @commit == 'Search' || @query.present?
  end

  def messages?
    @messages.present?
  end

  private

  def search
    return unless search?

    api = NutritionIx.new(@query)
    @recipe.foods << Food.find_or_create_from_api(api.foods)
    @messages = api.errors? ? api.messages : I18n.t('recipes.search.success')

    api
  end
end
