SELECT logs.id AS log_id,
entries.id AS entry_id,
recipes.id AS recipe_id,
entries.quantity AS quantity,
recipes.name AS recipe_name,
entries.category AS category,
sum(stats.calories * entries.quantity) AS calories,
sum(stats.carbs * entries.quantity) AS carbs,
sum(stats.protein * entries.quantity) AS protein,
sum(stats.fat * entries.quantity) AS fat
FROM logs
JOIN entries ON logs.id = entries.log_id
JOIN recipes ON recipes.id = entries.recipe_id
JOIN stats ON stats.recipe_id = entries.recipe_id
GROUP BY logs.id, entries.id, recipes.id, entries.quantity, recipes.name, entries.category
ORDER BY entries.id ASC;