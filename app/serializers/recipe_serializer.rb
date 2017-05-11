class RecipeSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :privacy_setting,
             :per_ingredient_stats,
             :total_stats
end
