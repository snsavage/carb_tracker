require 'rails_helper'

RSpec.feature 'UserCanManageFoods', type: :feature do
  let(:user) { create(:user) }

  feature 'FoodsController#index' do
    scenario 'foods are sorting ascending by default' do
      login_as(user, scope: :user)

      create_list(:user_food, 2, user: user)

      visit foods_path

      foods_from_page = [all('.food').first.text, all('.food').last.text]
      foods_from_db = Food.order(unique_name: :asc).map(&:unique_name)

      expect(foods_from_page).to eq(foods_from_db)
    end

    scenario 'user can sort foods descending by unique_name' do
      login_as(user, scope: :user)

      create_list(:user_food, 2, user: user)

      visit foods_path
      click_link "Descending"

      foods_from_page = [all('.food').first.text, all('.food').last.text]
      foods_from_db = Food.order(unique_name: :desc).map(&:unique_name)

      expect(foods_from_page).to eq(foods_from_db)
    end

    scenario 'user can switch foods sort order' do
      login_as(user, scope: :user)

      create_list(:user_food, 2, user: user)

      visit foods_path
      click_link "Descending"
      click_link "Ascending"

      foods_from_page = [all('.food').first.text, all('.food').last.text]
      foods_from_db = Food.order(unique_name: :asc).map(&:unique_name)

      expect(foods_from_page).to eq(foods_from_db)
    end

    scenario 'user can their view foods, but not other users foods' do
      login_as(user, scope: :user)

      create_list(:user_food, 2, user: user)

      food_from_other_user = create(:user_food)

      visit foods_path
      expect(page).to have_content(user.foods.first.unique_name)
      expect(page).to have_content(user.foods.last.unique_name)
      expect(page).not_to have_content(food_from_other_user.unique_name)
    end

    scenario 'user can view their foods and foods from NutritionIx' do
      login_as(user, scope: :user)

      create(:user_food, user: user)
      from_api = create(:api_food)

      food_from_other_user = create(:user_food)

      visit foods_path
      expect(page).to have_content(user.foods.first.unique_name)
      expect(page).to have_content(from_api.unique_name)
      expect(page).not_to have_content(food_from_other_user.unique_name)
    end
  end

  feature 'FoodsController#show' do
    scenario 'user can view their own foods' do
      login_as(user, scope: :user)
      food = create(:user_food, user: user)

      visit food_path(food)
      expect(page).to have_content(food.unique_name)
      expect(page).to have_content('Edit Food')
      expect(page).to have_content('Destroy Food')
    end

    scenario 'user can view api foods' do
      login_as(user, scope: :user)
      food = create(:api_food)

      visit food_path(food)
      expect(page).to have_content(food.unique_name)
      expect(page).not_to have_content('Edit Food')
      expect(page).not_to have_content('Destroy Food')
    end

    scenario 'user cannot view other users foods' do
      login_as(user, scope: :user)
      food = create(:user_food)

      visit food_path(food)
      expect(page).to have_current_path(root_path)
    end
  end

  feature 'FoodsController#destroy' do
    scenario 'user can delete their own foods' do
      login_as(user, scope: :user)
      food = create(:user_food, user: user)

      visit food_path(food)
      expect { click_link 'Destroy Food' }.to change { Food.count }.by(-1)
      expect(page).to have_current_path(foods_path)
    end
  end

  feature 'FoodController#new' do
    scenario 'with the valid attributes' do
      login_as(user, scope: :user)
      food = build(:user_food, user: user)

      visit new_food_path

      fill_in 'Name', with: food.food_name
      fill_in 'Serving qty', with: food.serving_qty
      fill_in 'Serving unit', with: food.serving_unit
      fill_in 'Calories', with: food.calories
      fill_in 'Total fat', with: food.total_fat
      fill_in 'Total carbohydrate', with: food.total_carbohydrate
      fill_in 'Protein', with: food.protein

      expect { click_button 'Create Food' }.to change { Food.count }.by(1)
    end
  end

  feature 'FoodController#edit' do
    scenario 'with valid attributes' do
      login_as(user, scope: :user)
      food = create(:user_food, user: user)

      visit edit_food_path(food)

      food_name = 'New Food'

      fill_in 'Name', with: food_name

      click_button 'Update Food'
      expect(Food.last.food_name).to eq food_name
    end
  end
end
