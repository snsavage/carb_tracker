module FoodStats
  FoodStats = Struct.new(:calories, :carbs, :protein, :fat)

  def stats
    calories, carbs, protein, fat = foods.stats
    FoodStats.new(calories, carbs, protein, fat)
  end
end
