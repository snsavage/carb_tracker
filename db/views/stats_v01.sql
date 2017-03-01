SELECT recipes.id AS recipe_id,
  ingredients.id AS ingredient_id,
  foods.id AS food_id, 
  foods.calories * ingredients.quantity / recipes.serving_size AS calories,
  foods.total_carbohydrate * ingredients.quantity / recipes.serving_size AS carbs,
  foods.protein * ingredients.quantity / recipes.serving_size AS protein,
  foods.total_fat * ingredients.quantity  / recipes.serving_size AS fat
FROM foods
JOIN ingredients ON foods.id = ingredients.food_id
JOIN recipes ON ingredients.recipe_id = recipes.id
GROUP BY recipes.id, ingredients.id, foods.id
ORDER BY recipes.id ASC;
