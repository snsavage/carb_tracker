require 'rails_helper'

RSpec.feature "UserCanManageFoods", type: :feature do
  let(:user) { create(:user) }

  feature "FoodsController#index" do
    scenario "user can their view foods, but not from other users" do
      login_as(user, scope: :user)

      food_one = create(:food, user_id: user.id)
      food_two = create(:food, user_id: user.id)

      other_food = create(:user_food)

      visit foods_path
      expect(page).to have_content(food_one.unique_name)
      expect(page).to have_content(food_two.unique_name)
      expect(page).not_to have_content(other_food.unique_name)
    end

    scenario "user can view their foods and foods from NutritionIx" do
      login_as(user, scope: :user)

      food_one = create(:food, user_id: user.id)
      from_api = create(:api_food)

      other_food = create(:user_food)

      visit foods_path
      expect(page).to have_content(food_one.unique_name)
      expect(page).to have_content(from_api.unique_name)
      expect(page).not_to have_content(other_food.unique_name)
    end
  end
end
