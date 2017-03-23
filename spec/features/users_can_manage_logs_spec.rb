require 'rails_helper'

RSpec.feature 'UsersCanManageLogFoods', :vcr, type: :feature do
  feature 'user can add an entry to a log' do
    scenario 'when signed in', js: true do
      user = create(:user)
      create(:recipe, user: user)

      login_as(user, scope: :user)

      visit new_user_log_path(user)

      expect(page).to have_current_path(new_user_log_path(user))

      click_button 'Add Entry'

      select 'Apple', from: 'Recipe'
      fill_in 'Quantity', with: '1'
      select 'Snack', from: 'Category'

      click_button 'Create Log'

      expect(page).to have_content('Apple')
      expect(page).to have_content('Snack')
    end

    scenario 'when not signed in' do
      user = create(:user)
      visit new_user_log_path(user)

      expect(page).to have_current_path(new_user_session_path)
    end

    scenario 'user can add multiple entries to a log', js: true do
      user = create(:user)
      recipe = create(:recipe, user: user)

      login_as(user, scope: :user)

      visit new_user_log_path(user)

      click_button 'Add Entry'

      within '#entries div:first-child' do
        select 'Apple', from: 'Recipe'
        fill_in 'Quantity', with: '1'
        select 'Snack', from: 'Category'
      end

      click_link 'Add Entry'

      within '#entries div:nth-child(2)' do
        select 'Apple', from: 'Recipe'
        fill_in 'Quantity', with: '1'
        select 'Breakfast', from: 'Category'
      end

      click_button 'Create Log'

      user.reload
      expect(user.logs.first.entries.count).to eq(2)
      expect(page).to have_content("#{recipe.title} - Snack")
      expect(page).to have_content("#{recipe.title} - Breakfast")
    end
  end

  feature 'users can remove entries from their logs', js: true do
    scenario 'when signed in' do
      user = create(:user)
      recipe = build(:recipe)
      food = create(:api_food)
      recipe.foods << food
      recipe.save

      user.logs.create(log_date: Time.current.to_date).recipes << recipe
      user.logs.first.recipes << recipe
      user.save

      expect(user.logs.first.entries.count).to eq(2)
      login_as(user, scope: :user)

      visit edit_user_log_path(user, user.logs.first)

      click_link 'Remove Entry', match: :first
      click_button 'Update Log'

      expect(user.logs.first.entries.count).to eq(1)
    end
  end
end
