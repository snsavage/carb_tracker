User.create(email: "snsavage@gmail.com", password: "password")
User.create(email: "example@example.com", password: "password")

kalua_pig = <<-RECIPE
3 slices of bacon
5 pound bone-in pork shoulder roast
5 peeled garlic cloves
1.5 tablespoons of Alaea Red Hawaiian Coarse Sea Salt
1 cup water
1 small cabbage, cored, and cut into 6 wedges
RECIPE

chile_lime_chicken_wings = <<-RECIPE
0.5 medium onion, roughly chopped
2 jalapeno peppers (or 1 serrano pepper), ribs and seeds removed
3 garlic cloves, peeled
0.5 cup cilantro, tightly packed
Freshly ground pepper
Zest from 2 limes
0.25 cup lime juice
2 tablespoons Paleo-friendly fish sauce (Red Boat!)
2 tablespoons coconut aminos
6 pounds chicken wings and/or drumsticks
2 tablespoons melted fat of choice
4 limes, cut into wedges
RECIPE

recipe_1 = Recipe.create(name: "Kalua Pig", serving_size: 8)
foods_1 = NutritionIx.new(kalua_pig).foods
recipe_1.foods << Food.find_or_create_from_api(foods_1)
recipe_1.save

recipe_2 = Recipe.create(name: "Chile Lime Chicken Wings", serving_size: 8)
foods_2 = NutritionIx.new(chile_lime_chicken_wings).foods
recipe_2.foods << Food.find_or_create_from_api(foods_2)
recipe_2.save



