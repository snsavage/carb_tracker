require 'rails_helper'

RSpec.feature 'UserCanManageRecipes', type: :feature do
  let(:user) { create(:user) }

  feature 'RecipesController#index' do
    scenario 'user can view their recipes and public recipes' do
      login_as(user, scope: :user)

      recipe = create(:recipe, user: user)
      public_recipe = create(:recipe, public: true)
      private_recipe = create(:recipe)

      visit recipes_path

      expect(page).to have_content(recipe.title)
      expect(page).to have_content(public_recipe.title)
      expect(page).not_to have_content(private_recipe.title)
    end
  end

  feature 'RecipesController#show' do
    scenario 'user can view their own recipes' do
      recipe = create(:recipe, user: user)

      login_as(user, scope: :user)
      visit recipe_path(recipe)

      expect(page).to have_content(recipe.title)
      expect(page).to have_content('Edit Recipe')
      expect(page).to have_content('Destroy Recipe')
    end

    scenario 'user can view, but cannot manage public recipes' do
      recipe = create(:recipe, public: true)

      login_as(user, scope: :user)
      visit recipe_path(recipe)

      expect(page).to have_content(recipe.title)
      expect(page).not_to have_content('Edit Recipe')
      expect(page).not_to have_content('Destroy Recipe')
    end
  end

  feature 'RecipesController#new' do
    scenario 'new foods with errors can be fixed and saved', :vcr, js: true do
      login_as(user, scope: :user)
      food = build(:user_food, user: user)

      visit new_recipe_path
      fill_in 'Recipe Name', with: 'New Recipe'

      click_button 'Add Food'
      fill_in 'Name', with: food.food_name

      click_button 'Create Recipe'

      fill_in 'Serving qty', with: food.serving_qty
      fill_in 'Serving unit', with: food.serving_unit
      fill_in 'Calories', with: food.calories
      fill_in 'Total fat', with: food.total_fat
      fill_in 'Total carbohydrate', with: food.total_carbohydrate
      fill_in 'Protein', with: food.protein

      expect do
        click_button 'Create Recipe'
      end.to change { Food.count }.by(1)
    end

    scenario 'extra ingredient does not show with form error', :vcr, js: true do
      login_as(user, scope: :user)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'

      click_button 'Add Food'
      click_button 'Create Recipe'

      expect(page).not_to have_content('Remove Ingredient')
    end

    scenario 'create a new food when creating a recipe', :vcr, js: true do
      login_as(user, scope: :user)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'

      click_button 'Add Food'

      fill_in 'Name', with: 'Banana'
      fill_in 'Serving qty', with: 1.0
      fill_in 'Serving unit', with: 'Medium'
      fill_in 'Calories', with: 100
      fill_in 'Total fat', with: 100
      fill_in 'Total carbohydrate', with: 100
      fill_in 'Protein', with: 100

      expect do
        click_button 'Create Recipe'
      end.to change { Recipe.count }.by(1)

      expect(Recipe.last.foods.count).to eq(1)
      expect(page).to have_current_path(recipe_path(Recipe.last))
    end

    scenario 'Users can create recipes by searching for foods', :vcr do
      login_as(user, scope: :user)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'
      fill_in 'Search', with: '1 Apple'
      click_button 'Search'

      expect(page).to have_content('New Recipe')
      expect(page).to have_content('Apple - 1.0 - Medium')

      expect do
        click_button 'Create Recipe'
      end.to change { Recipe.count }.by(1)
    end

    scenario 'Users can create recipes with existing foods', :vcr, js: true do
      login_as(user, scope: :user)
      food = create(:api_food)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'

      click_button 'Add Ingredient'
      select food.unique_name, from: 'Food'

      expect do
        click_button 'Create Recipe'
      end.to change { Recipe.count }.by(1)
    end

    scenario 'blank search field will shows proper errors to user', :vcr do
      login_as(user, scrope: :user)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'
      fill_in 'Search', with: ''
      click_button 'Search'

      expect(page).to have_content('New Recipe')
      expect(page).to have_content('Please provide a search term')
      expect(page).not_to have_content('Your form couldn\'t be processed')
    end

    scenario 'search with no results shows proper errors to user', :vcr do
      login_as(user, scrope: :user)

      visit new_recipe_path

      fill_in 'Recipe Name', with: 'New Recipe'
      fill_in 'Search', with: 'hammer'
      click_button 'Search'

      expect(page).to have_content('New Recipe')
      expect(page).to have_content('We couldn\'t match any of your foods')
    end

    scenario 'with an invalid recipe entry' do
      login_as(user, scrope: :user)

      visit new_recipe_path

      click_button 'Create Recipe'

      expect(page).to have_content('Name can\'t be blank')
      expect(page).to have_content('Ingredients can\'t be blank')
    end
  end

  feature 'RecipesController#edit' do
    scenario 'users can edit existing recipes' do
      login_as(user, scope: :user)
      recipe = create(:recipe, user: user)

      visit edit_recipe_path(recipe)

      fill_in 'Recipe Name', with: 'Updated Name'

      click_button 'Update Recipe'

      expect(page).to have_content('Updated Name')
    end

    scenario 'users can remove ingredients from recipes', :vcr, js: true do
      login_as(user, scope: :user)
      recipe = create(:recipe, user: user, food_count: 2)

      visit edit_recipe_path(recipe)

      click_button 'Remove Ingredient', match: :first

      expect do
        click_button 'Update Recipe'
      end.to change { recipe.foods.count }.by(-1)
    end

    scenario 'users can search recipe foods', :vcr, js: true do
      login_as(user, scrope: user)
      recipe = create(:recipe, user: user)

      visit edit_recipe_path(recipe)

      fill_in 'Search', with: '1 Banana'

      expect { click_button 'Search' }.to change { recipe.foods.count }.by(1)
    end
  end

  feature 'RecipesController#destroy' do
    scenario 'users can destroy their recipes' do
      login_as(user, scope: :user)
      recipe = create(:recipe, user: user)

      visit recipe_path(recipe)

      expect { click_link 'Destroy Recipe' }.to change { Recipe.count }.by(-1)

      expect(page).to have_current_path(recipes_path)
    end
  end
end
